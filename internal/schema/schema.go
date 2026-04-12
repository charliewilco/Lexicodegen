package schema

import (
	"bytes"
	"encoding/json"
	"fmt"
	"sort"
	"strings"

	indigolexicon "github.com/bluesky-social/indigo/atproto/lexicon"
)

type Document struct {
	Lexicon     int               `json:"lexicon"`
	ID          string            `json:"id"`
	Description string            `json:"description,omitempty"`
	Defs        map[string]Schema `json:"defs"`
}

type Schema struct {
	Type        string            `json:"type,omitempty"`
	Format      string            `json:"format,omitempty"`
	Description string            `json:"description,omitempty"`
	Required    []string          `json:"required,omitempty"`
	Nullable    []string          `json:"nullable,omitempty"`
	Properties  map[string]Schema `json:"properties,omitempty"`
	Items       *Schema           `json:"items,omitempty"`
	KnownValues []string          `json:"knownValues,omitempty"`
	Ref         string            `json:"ref,omitempty"`
	Refs        []string          `json:"refs,omitempty"`
	Record      *Schema           `json:"record,omitempty"`
	Schema      *Schema           `json:"schema,omitempty"`
	Parameters  *Schema           `json:"parameters,omitempty"`
	Input       *InputSchema      `json:"input,omitempty"`
	Output      *OutputSchema     `json:"output,omitempty"`
	Message     *MessageSchema    `json:"message,omitempty"`
	Errors      []SchemaError     `json:"errors,omitempty"`
	Permissions []Schema          `json:"permissions,omitempty"`
	LXM         []string          `json:"lxm,omitempty"`
	Accept      []string          `json:"accept,omitempty"`
	Closed      bool              `json:"closed,omitempty"`
	Encoding    string            `json:"encoding,omitempty"`
	Key         string            `json:"key,omitempty"`
	Title       string            `json:"title,omitempty"`
	Detail      string            `json:"detail,omitempty"`
	raw         any
}

type InputSchema struct {
	Encoding string  `json:"encoding,omitempty"`
	Schema   *Schema `json:"schema,omitempty"`
}

type OutputSchema struct {
	Encoding string  `json:"encoding,omitempty"`
	Schema   *Schema `json:"schema,omitempty"`
}

type MessageSchema struct {
	Schema *Schema `json:"schema,omitempty"`
}

type SchemaError struct {
	Name        string `json:"name,omitempty"`
	Description string `json:"description,omitempty"`
}

func (s *Schema) UnmarshalJSON(data []byte) error {
	type alias Schema
	var decoded alias
	if err := json.Unmarshal(data, &decoded); err != nil {
		return err
	}

	var raw any
	if err := json.Unmarshal(data, &raw); err != nil {
		return err
	}

	*s = Schema(decoded)
	s.raw = raw
	return nil
}

func (s Schema) Raw() any {
	if s.raw != nil {
		return s.raw
	}
	return map[string]any{}
}

func ParseDocuments(data []byte) ([]Document, error) {
	trimmed := bytes.TrimSpace(data)
	if len(trimmed) == 0 {
		return nil, fmt.Errorf("empty lexicon payload")
	}

	if trimmed[0] == '[' {
		var messages []json.RawMessage
		if err := json.Unmarshal(trimmed, &messages); err != nil {
			return nil, err
		}

		docs := make([]Document, 0, len(messages))
		for _, message := range messages {
			doc, err := parseSingleDocument(message)
			if err != nil {
				return nil, err
			}
			docs = append(docs, doc)
		}
		return docs, nil
	}

	doc, err := parseSingleDocument(trimmed)
	if err != nil {
		return nil, err
	}
	return []Document{doc}, nil
}

func parseSingleDocument(data []byte) (Document, error) {
	var validated indigolexicon.SchemaFile
	if err := json.Unmarshal(data, &validated); err != nil {
		return Document{}, err
	}
	if err := validated.FinishParse(); err != nil {
		return Document{}, err
	}
	if err := validated.CheckSchema(); err != nil {
		return Document{}, err
	}

	var doc Document
	if err := json.Unmarshal(data, &doc); err != nil {
		return Document{}, err
	}
	if doc.Defs == nil {
		doc.Defs = map[string]Schema{}
	}
	return doc, nil
}

func NormalizeRef(ref string, currentID string) string {
	if strings.HasPrefix(ref, "#") {
		return currentID + "." + strings.TrimPrefix(ref, "#")
	}
	if strings.Contains(ref, "#") {
		return strings.Replace(ref, "#", ".", 1)
	}
	return ref
}

func SortedDefNames(doc Document) []string {
	names := make([]string, 0, len(doc.Defs))
	for name := range doc.Defs {
		names = append(names, name)
	}
	sort.Strings(names)
	return names
}
