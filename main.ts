import { styleText } from "node:util";
import { loadGeneratorConfig } from "./lib/config";
import { emitSwiftFromIR } from "./lib/emitter/swift";
import { buildLexiconIR } from "./lib/lexicon-ir";
import { loadLexiconsFromSources } from "./lib/lexicon-loader";

async function run() {
	const config = await loadGeneratorConfig();
	const docs = await loadLexiconsFromSources(config.sources);
	const ir = buildLexiconIR(docs, config.filters);

	console.log(styleText("green", "Lexicon generator"));
	console.log(
		styleText(["blue", "bold"], "Loaded"),
		styleText("bold", `${docs.length}`),
		styleText(["blue", "bold"], "lexicon documents"),
	);

	console.log(
		styleText(["blue", "bold"], "Configured targets:"),
		styleText("bold", config.targets.join(", ")),
	);

	for (const target of config.targets) {
		if (target === "swift") {
			console.log(
				styleText("yellow", "Generating Swift"),
				styleText("blue", config.output.swiftOutDir),
			);
			await emitSwiftFromIR(ir, config.output.swiftOutDir);
		}
	}
}

try {
	await run();
} catch (error) {
	if (error instanceof Error) {
		console.error(styleText("red", "Error:"), error.message);
	} else {
		console.error(styleText("red", "Unknown error occurred"));
	}
	process.exitCode = 1;
}
