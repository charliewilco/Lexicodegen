package ir

import (
	"sort"
	"strings"

	"github.com/charliewilco/lexicon-openapi-generator/internal/config"
	"github.com/charliewilco/lexicon-openapi-generator/internal/schema"
	"github.com/charliewilco/lexicon-openapi-generator/internal/util"
)

type EndpointError struct {
	Name        string
	Description string
}

type NamedType struct {
	ID         string
	Name       string
	FullName   string
	Definition schema.Schema
	Source     string
	Tag        string
	Type       string
}

type Endpoint struct {
	ID               string
	Name             string
	FullName         string
	Definition       schema.Schema
	Method           string
	Source           string
	Tag              string
	Path             string
	ParametersSchema *schema.Schema
	InputSchema      *schema.Schema
	InputEncoding    string
	OutputSchema     *schema.Schema
	OutputEncoding   string
	MessageSchema    *schema.Schema
	Errors           []EndpointError
}

type Document struct {
	ID        string
	Source    string
	Defs      []NamedType
	Endpoints []Endpoint
}

type LexiconIR struct {
	Documents       []Document
	NamedTypes      []NamedType
	Endpoints       []Endpoint
	DefinitionIndex map[string]NamedType
}

type IRBuilder interface {
	Build(lexiconDocs []schema.Document, filters config.GenerationFilter) LexiconIR
}

type Builder struct{}

func (Builder) Build(lexiconDocs []schema.Document, filters config.GenerationFilter) LexiconIR {
	return BuildLexiconIR(lexiconDocs, filters)
}

type definitionCandidate struct {
	DocID      string
	Name       string
	FullName   string
	Definition schema.Schema
	Source     string
	Tag        string
	Type       string
}

func BuildLexiconIR(lexiconDocs []schema.Document, filters config.GenerationFilter) LexiconIR {
	sortedDocs := append([]schema.Document(nil), lexiconDocs...)
	sort.Slice(sortedDocs, func(i, j int) bool {
		return sortedDocs[i].ID < sortedDocs[j].ID
	})

	candidates := map[string]definitionCandidate{}
	docCandidates := map[string][]definitionCandidate{}

	for _, doc := range sortedDocs {
		names := schema.SortedDefNames(doc)
		tag := util.CalculateTag(doc.ID)
		perDoc := make([]definitionCandidate, 0, len(names))

		for _, name := range names {
			definition := doc.Defs[name]
			if strings.TrimSpace(definition.Type) == "" {
				continue
			}
			fullName := doc.ID
			if name != "main" {
				fullName += "." + name
			}
			candidate := definitionCandidate{
				DocID:      doc.ID,
				Name:       name,
				FullName:   fullName,
				Definition: definition,
				Source:     doc.ID,
				Tag:        tag,
				Type:       definition.Type,
			}
			candidates[fullName] = candidate
			perDoc = append(perDoc, candidate)
		}

		docCandidates[doc.ID] = perDoc
	}

	included := map[string]bool{}
	queue := []string{}
	for _, candidate := range candidates {
		if shouldIncludeDefinition(candidate.FullName, candidate.Definition, filters) {
			included[candidate.FullName] = true
			queue = append(queue, candidate.FullName)
		}
	}

	for len(queue) > 0 {
		next := queue[0]
		queue = queue[1:]

		candidate, ok := candidates[next]
		if !ok {
			continue
		}

		refs := collectReferencedDefinitions(candidate.Definition.Raw(), candidate.DocID, map[string]bool{})
		refNames := make([]string, 0, len(refs))
		for ref := range refs {
			refNames = append(refNames, ref)
		}
		sort.Strings(refNames)
		for _, ref := range refNames {
			if !included[ref] {
				if _, ok := candidates[ref]; ok {
					included[ref] = true
					queue = append(queue, ref)
				}
			}
		}
	}

	var documents []Document
	var namedTypes []NamedType
	var endpoints []Endpoint

	for _, doc := range sortedDocs {
		perDoc := docCandidates[doc.ID]
		var docNamedTypes []NamedType
		var docEndpoints []Endpoint

		for _, candidate := range perDoc {
			if !included[candidate.FullName] {
				continue
			}

			switch candidate.Type {
			case "query", "procedure", "subscription":
				endpoint := toEndpoint(candidate)
				docEndpoints = append(docEndpoints, endpoint)
				endpoints = append(endpoints, endpoint)
			default:
				namedType := NamedType{
					ID:         candidate.DocID,
					Name:       candidate.Name,
					FullName:   candidate.FullName,
					Definition: candidate.Definition,
					Source:     candidate.Source,
					Tag:        candidate.Tag,
					Type:       candidate.Type,
				}
				docNamedTypes = append(docNamedTypes, namedType)
				namedTypes = append(namedTypes, namedType)
			}
		}

		if len(docNamedTypes) == 0 && len(docEndpoints) == 0 {
			continue
		}
		documents = append(documents, Document{
			ID:        doc.ID,
			Source:    doc.ID,
			Defs:      docNamedTypes,
			Endpoints: docEndpoints,
		})
	}

	sort.Slice(documents, func(i, j int) bool { return documents[i].ID < documents[j].ID })
	sort.Slice(namedTypes, func(i, j int) bool { return namedTypes[i].FullName < namedTypes[j].FullName })
	sort.Slice(endpoints, func(i, j int) bool { return endpoints[i].FullName < endpoints[j].FullName })

	index := map[string]NamedType{}
	for _, namedType := range namedTypes {
		index[namedType.FullName] = namedType
	}

	return LexiconIR{
		Documents:       documents,
		NamedTypes:      namedTypes,
		Endpoints:       endpoints,
		DefinitionIndex: index,
	}
}

func shouldIncludeDefinition(id string, definition schema.Schema, filters config.GenerationFilter) bool {
	if len(filters.AllowPrefixes) > 0 {
		matched := false
		for _, prefix := range filters.AllowPrefixes {
			if strings.HasPrefix(id, prefix) {
				matched = true
				break
			}
		}
		if !matched {
			return false
		}
	}

	for _, prefix := range filters.DenyPrefixes {
		if strings.HasPrefix(id, prefix) {
			return false
		}
	}

	if filters.DenyUnspecced && strings.Contains(id, ".unspecced.") {
		return false
	}
	if filters.DenyDeprecated && util.IsDeprecatedDefinition(definition.Description) {
		return false
	}
	return true
}

func collectReferencedDefinitions(value any, currentID string, references map[string]bool) map[string]bool {
	switch typed := value.(type) {
	case []any:
		for _, item := range typed {
			collectReferencedDefinitions(item, currentID, references)
		}
	case map[string]any:
		if ref, ok := typed["ref"].(string); ok {
			references[schema.NormalizeRef(ref, currentID)] = true
		}
		if refs, ok := typed["refs"].([]any); ok {
			for _, raw := range refs {
				if ref, ok := raw.(string); ok {
					references[schema.NormalizeRef(ref, currentID)] = true
				}
			}
		}
		for _, nested := range typed {
			collectReferencedDefinitions(nested, currentID, references)
		}
	}
	return references
}

func toEndpoint(candidate definitionCandidate) Endpoint {
	errors := make([]EndpointError, 0, len(candidate.Definition.Errors))
	for _, endpointError := range candidate.Definition.Errors {
		if endpointError.Name == "" {
			continue
		}
		errors = append(errors, EndpointError{
			Name:        endpointError.Name,
			Description: endpointError.Description,
		})
	}
	sort.Slice(errors, func(i, j int) bool { return errors[i].Name < errors[j].Name })

	var parameters *schema.Schema
	if candidate.Definition.Parameters != nil && candidate.Definition.Parameters.Type == "params" {
		parameters = candidate.Definition.Parameters
	}

	return Endpoint{
		ID:               candidate.DocID,
		Name:             candidate.Name,
		FullName:         candidate.FullName,
		Definition:       candidate.Definition,
		Method:           candidate.Type,
		Source:           candidate.Source,
		Tag:              candidate.Tag,
		Path:             "/xrpc/" + candidate.DocID,
		ParametersSchema: parameters,
		InputSchema:      schemaPointer(candidate.Definition.Input, func(input *schema.InputSchema) *schema.Schema { return input.Schema }),
		InputEncoding:    stringPointer(candidate.Definition.Input, func(input *schema.InputSchema) string { return input.Encoding }),
		OutputSchema:     schemaPointer(candidate.Definition.Output, func(output *schema.OutputSchema) *schema.Schema { return output.Schema }),
		OutputEncoding:   stringPointer(candidate.Definition.Output, func(output *schema.OutputSchema) string { return output.Encoding }),
		MessageSchema:    schemaPointer(candidate.Definition.Message, func(message *schema.MessageSchema) *schema.Schema { return message.Schema }),
		Errors:           errors,
	}
}

func schemaPointer[T any](value *T, selector func(*T) *schema.Schema) *schema.Schema {
	if value == nil {
		return nil
	}
	return selector(value)
}

func stringPointer[T any](value *T, selector func(*T) string) string {
	if value == nil {
		return ""
	}
	return selector(value)
}
