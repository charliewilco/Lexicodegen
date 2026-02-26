import fs from "node:fs/promises";
import path from "node:path";
import { parseArgs as parseCommandArgs } from "node:util";

export type Target = "swift";

export type LexiconSource =
	| { kind: "local"; path: string; recursive?: boolean }
	| { kind: "http"; url: string }
	| {
			kind: "git-archive";
			url: string;
			stripPath?: string;
			branch?: string;
	  };

export type GenerationFilter = {
	allowPrefixes?: string[];
	denyPrefixes?: string[];
	denyUnspecced?: boolean;
	denyDeprecated?: boolean;
};

export type GeneratorConfig = {
	sources: LexiconSource[];
	filters: GenerationFilter;
	targets: Target[];
	output: {
		swiftOutDir: string;
	};
};

type RawConfig = {
	sources?: LexiconSource[];
	filters?: GenerationFilter;
	targets?: string[];
	output?: {
		swiftOutDir?: string;
	};
};

function normalizeConfig(rawConfigPath: string): string {
	return path.extname(rawConfigPath) === ".toml" ? "toml" : "json";
}

async function loadConfigFile(rawConfigPath: string): Promise<RawConfig> {
	const rawConfig = await fs.readFile(
		normalizeConfigPath(rawConfigPath),
		"utf8",
	);
	const configFormat = normalizeConfig(rawConfigPath);

	if (configFormat === "toml") {
		return Bun.TOML.parse(rawConfig) as RawConfig;
	}

	return JSON.parse(rawConfig) as RawConfig;
}

type RawCli = {
	configPath?: string;
	sources: LexiconSource[];
	positionalSources: string[];
	allowPrefixes: string[];
	denyPrefixes: string[];
	targets: string[];
	swiftOutputDir?: string;
	outputDir?: string;
	denyUnspecced?: boolean;
	denyDeprecated?: boolean;
};

const DEFAULT_OUTPUT = {
	swiftOutDir: "./output/swift",
};

const DEFAULT_CONFIG: GeneratorConfig = {
	sources: [{ kind: "local", path: "./lexicons", recursive: true }],
	filters: {
		allowPrefixes: [],
		denyPrefixes: [],
		denyUnspecced: false,
		denyDeprecated: false,
	},
	targets: ["swift"],
	output: DEFAULT_OUTPUT,
};

function parseSourceArgument(source: string): LexiconSource {
	if (source.startsWith("git-archive:")) {
		return {
			kind: "git-archive",
			url: source.slice("git-archive:".length),
		};
	}

	if (source.startsWith("local:")) {
		return { kind: "local", path: source.slice("local:".length) };
	}

	if (source.startsWith("http://") || source.startsWith("https://")) {
		return { kind: "http", url: source };
	}

	return { kind: "local", path: source };
}

function parseListArg(values: string[] | string): string[] {
	const expanded = Array.isArray(values)
		? values.flatMap((value) => value.split(","))
		: values.split(",");

	return expanded
		.map((value) => value.trim())
		.filter((value): value is string => value.length > 0);
}

function normalizeTargets(values: string[] | undefined): Target[] {
	const flat = parseListArg(values ?? ["swift"]).map((value) =>
		value.trim().toLowerCase(),
	);
	const set = new Set<Target>();

	for (const value of flat) {
		if (value === "swift") {
			set.add("swift");
		}

		if (value === "both") {
			set.add("swift");
		}
	}

	return set.size > 0 ? Array.from(set) : ["swift"];
}

function normalizeConfigPath(raw: string): string {
	return path.resolve(process.cwd(), raw);
}

function parseArgs(argv: string[]): RawCli {
	const parsed: RawCli = {
		sources: [],
		positionalSources: [],
		allowPrefixes: [],
		denyPrefixes: [],
		targets: [],
	};

	const parsedArguments = parseCommandArgs({
		args: argv,
		allowPositionals: true,
		options: {
			config: { type: "string" },
			targets: { type: "string", multiple: true },
			target: { type: "string", multiple: true },
			source: { type: "string", multiple: true },
			"allow-prefix": { type: "string", multiple: true },
			"deny-prefix": { type: "string", multiple: true },
			output: { type: "string" },
			"swift-output-dir": { type: "string" },
			"deny-unspecced": { type: "boolean" },
			"deny-deprecated": { type: "boolean" },
		},
		strict: false,
	});

	const values = parsedArguments.values;
	const positionals = parsedArguments.positionals;

	const collectStringValues = (name: string): string[] => {
		const raw = values[name];
		if (typeof raw === "string") {
			return [raw];
		}

		if (Array.isArray(raw)) {
			return raw.filter(
				(value): value is string =>
					typeof value === "string" && value.length > 0,
			);
		}

		return [];
	};

	const configValues = collectStringValues("config");
	if (configValues.length > 0) {
		parsed.configPath = configValues[0];
	}

	for (const rawTargets of collectStringValues("targets")) {
		parsed.targets.push(...parseListArg(rawTargets));
	}

	for (const rawTargets of collectStringValues("target")) {
		parsed.targets.push(...parseListArg(rawTargets));
	}

	for (const source of collectStringValues("source")) {
		parsed.sources.push(parseSourceArgument(source));
	}

	const outputValues = collectStringValues("output");
	if (outputValues.length > 0) {
		parsed.outputDir = outputValues[0];
	}

	const swiftOutputValues = collectStringValues("swift-output-dir");
	if (swiftOutputValues.length > 0) {
		parsed.swiftOutputDir = swiftOutputValues[0];
	}

	for (const rawPrefix of collectStringValues("allow-prefix")) {
		parsed.allowPrefixes.push(...parseListArg(rawPrefix));
	}

	for (const rawPrefix of collectStringValues("deny-prefix")) {
		parsed.denyPrefixes.push(...parseListArg(rawPrefix));
	}

	if (values["deny-unspecced"] === true) {
		parsed.denyUnspecced = true;
	}

	if (values["deny-deprecated"] === true) {
		parsed.denyDeprecated = true;
	}

	for (const positional of positionals) {
		parsed.positionalSources.push(positional);
	}

	return parsed;
}

export async function loadGeneratorConfig(
	argv = process.argv.slice(2),
): Promise<GeneratorConfig> {
	const cli = parseArgs(argv);

	let fileConfig: RawConfig = {};

	if (cli.configPath) {
		fileConfig = await loadConfigFile(cli.configPath);
	}

	const defaults = DEFAULT_CONFIG;

	const mergedFilters = {
		allowPrefixes: (cli.allowPrefixes.length > 0
			? cli.allowPrefixes
			: (fileConfig.filters?.allowPrefixes ??
				defaults.filters.allowPrefixes ??
				[])
		).filter((prefix) => prefix.trim().length > 0),
		denyPrefixes: (cli.denyPrefixes.length > 0
			? cli.denyPrefixes
			: (fileConfig.filters?.denyPrefixes ??
				defaults.filters.denyPrefixes ??
				[])
		).filter((prefix) => prefix.trim().length > 0),
		denyUnspecced:
			cli.denyUnspecced ??
			fileConfig.filters?.denyUnspecced ??
			defaults.filters.denyUnspecced ??
			false,
		denyDeprecated:
			cli.denyDeprecated ??
			fileConfig.filters?.denyDeprecated ??
			defaults.filters.denyDeprecated ??
			false,
	};

	const mergedTargets = normalizeTargets(
		cli.targets.length > 0
			? cli.targets
			: (fileConfig.targets ?? defaults.targets),
	);

	const hasCliSources =
		cli.sources.length > 0 || cli.positionalSources.length > 0;

	const cliSourceInputs = [
		...cli.sources,
		...cli.positionalSources.map((source) => parseSourceArgument(source)),
	];

	const mergedSources = (
		hasCliSources ? cliSourceInputs : (fileConfig.sources ?? defaults.sources)
	).map((source) => {
		if (source.kind === "local") {
			return {
				...source,
				path: path.resolve(process.cwd(), source.path),
			};
		}

		return source;
	});

	const mergedOutput = {
		swiftOutDir:
			cli.outputDir ??
			cli.swiftOutputDir ??
			fileConfig.output?.swiftOutDir ??
			defaults.output.swiftOutDir,
	};

	return {
		sources: mergedSources,
		filters: mergedFilters,
		targets: mergedTargets,
		output: {
			swiftOutDir: path.resolve(process.cwd(), mergedOutput.swiftOutDir),
		},
	};
}
