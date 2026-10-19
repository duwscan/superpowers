import { readFileSync } from "node:fs";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";
import type { ExtensionAPI } from "@oh-my-pi/pi-coding-agent";

const EXTREMELY_IMPORTANT_MARKER = "<EXTREMELY_IMPORTANT>";
const BOOTSTRAP_MARKER = "superpowers:using-superpowers bootstrap for omp";

const extensionDir = dirname(fileURLToPath(import.meta.url));
const packageRoot = resolve(extensionDir, "../..");
const skillsDir = resolve(packageRoot, "skills");
const bootstrapSkillPath = resolve(skillsDir, "using-superpowers", "SKILL.md");

let cachedBootstrap: string | null | undefined;

export default function superpowersOmpExtension(pi: ExtensionAPI) {
	let injectBootstrap = true;

	// Skills are NOT registered here. OMP's omp-plugins provider discovers the
	// sibling skills/ directory of this extension package on its own; the
	// resources_discover event the pi extension uses has no callsites in OMP.

	pi.on("session_start", async () => {
		injectBootstrap = true;
	});

	pi.on("session_compact", async () => {
		injectBootstrap = true;
	});

	pi.on("agent_end", async () => {
		injectBootstrap = false;
	});

	pi.on("context", async (event) => {
		if (!injectBootstrap) return;
		if (event.messages.some(messageContainsBootstrap)) return;

		const bootstrap = getBootstrapContent();
		if (!bootstrap) return;

		const bootstrapMessage = {
			role: "user" as const,
			content: [{ type: "text" as const, text: bootstrap }],
			timestamp: Date.now(),
		};

		const insertAt = firstNonCompactionSummaryIndex(event.messages);
		return {
			messages: [
				...event.messages.slice(0, insertAt),
				bootstrapMessage,
				...event.messages.slice(insertAt),
			],
		};
	});
}

function getBootstrapContent(): string | null {
	if (cachedBootstrap !== undefined) return cachedBootstrap;

	try {
		const skillContent = readFileSync(bootstrapSkillPath, "utf8");
		const body = stripFrontmatter(skillContent);
		cachedBootstrap = `${EXTREMELY_IMPORTANT_MARKER}
${BOOTSTRAP_MARKER}

You have superpowers.

The using-superpowers skill content is included below and is already loaded for this OMP session. Follow it now. Do not try to load using-superpowers again.

${body}

${ompToolMapping()}
</EXTREMELY_IMPORTANT>`;
		return cachedBootstrap;
	} catch {
		cachedBootstrap = null;
		return null;
	}
}

function stripFrontmatter(content: string): string {
	const match = content.match(/^---\n[\s\S]*?\n---\n([\s\S]*)$/);
	return (match ? match[1] : content).trim();
}

function ompToolMapping(): string {
	return `## OMP tool mapping

OMP has native skills: your system prompt lists each one by name and description. When a Superpowers instruction says to invoke a skill, load it with \`read skill://<skill-name>/SKILL.md\`. Do not re-read using-superpowers — it is already loaded above. A human can also invoke \`/skill:<name>\` directly.

Built-in coding tools are lowercase: \`read\`, \`write\`, \`edit\`, \`bash\`, plus \`grep\` and \`glob\` for searching. Use those for the corresponding actions.

Subagent dispatch (Superpowers \`Subagent (general-purpose):\` templates) maps to the \`task\` tool: give each subagent a self-contained prompt with the full task text. Use the read-only \`scout\` agent for investigation and the general \`task\` agent for implementation work.

Model tiers per the dispatching skill's Model Selection: the \`task\` tool takes no direct model parameter — pin tiers by \`agent\` (custom agents with a \`model:\` line in \`.omp/agents/\`, or the \`task.agentModelOverrides\` setting), pass per-item \`effort\` when \`task.enableEffort\` is enabled, and always set \`solutionSpace\` honestly: it is the only input OMP's effort classifier reads.

Task tracking maps to the \`todo\` tool. Treat older \`TodoWrite\` references as this action.

Details: \`references/omp-tools.md\` in the using-superpowers skill.`;
}
function messageContainsBootstrap(message: unknown): boolean {
	if (message === null || typeof message !== "object") return false;
	if (!("content" in message)) return false;
	const content: unknown = message.content;
	if (typeof content === "string") return content.includes(BOOTSTRAP_MARKER);
	if (!Array.isArray(content)) return false;

	const parts: unknown[] = content;
	return parts.some((part) => {
		return (
			part !== null &&
			typeof part === "object" &&
			"type" in part &&
			part.type === "text" &&
			"text" in part &&
			typeof part.text === "string" &&
			part.text.includes(BOOTSTRAP_MARKER)
		);
	});
}

function firstNonCompactionSummaryIndex(messages: unknown[]): number {
	let index = 0;
	while (hasCompactionSummaryRole(messages[index])) {
		index += 1;
	}
	return index;
}

function hasCompactionSummaryRole(message: unknown): boolean {
	return (
		message !== null &&
		typeof message === "object" &&
		"role" in message &&
		message.role === "compactionSummary"
	);
}
