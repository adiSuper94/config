import { readdirSync, readFileSync } from "node:fs";
import { join } from "node:path";
import { fileURLToPath } from "node:url";
import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";

const STATE_TYPE = "hats.selection";
const SECTION = "hats_persona";
const definitionsDir = fileURLToPath(new URL("./definitions/", import.meta.url));

function loadHats(): Map<string, string> {
  const hats = new Map<string, string>();
  const entries = readdirSync(definitionsDir, { withFileTypes: true });
  for (const entry of entries) {
    if (!entry.isFile() || !entry.name.endsWith(".md")) continue;
    const name = entry.name.slice(0, -3);
    if (name === "off") throw new Error('Hats: "off" is a reserved hat name.');
    const instructions = readFileSync(join(definitionsDir, entry.name), "utf8").trim();
    if (!instructions) throw new Error(`Hats: ${entry.name} must contain instructions.`);
    hats.set(name, instructions);
  }
  return hats;
}

export default function hatsExtension(pi: ExtensionAPI) {
  const hats = loadHats();
  let activeHat: string | null = null;

  function updateStatus(ctx: ExtensionContext) {
    if (ctx.hasUI) ctx.ui.setStatus("hats", `Hat: ${activeHat ?? "off"}`);
  }

  function restoreSelection(ctx: ExtensionContext) {
    activeHat = null;
    // Follow the active branch, not selections from abandoned branches.
    for (const entry of ctx.sessionManager.getBranch().reverse()) {
      if (entry.type !== "custom" || entry.customType !== STATE_TYPE) continue;
      const data = entry.data as { hat?: unknown } | undefined;
      if (data && (data.hat === null || typeof data.hat === "string")) {
        activeHat = data.hat;
        break;
      }
    }
    if (activeHat !== null && !hats.has(activeHat)) {
      ctx.ui.notify(`Hat "${activeHat}" no longer exists; using off.`, "warning");
      activeHat = null;
    }
    updateStatus(ctx);
  }

  pi.on("session_start", (_event, ctx) => restoreSelection(ctx));
  pi.on("session_tree", (_event, ctx) => restoreSelection(ctx));

  pi.on("before_agent_start", (event) => {
    const hatDesc = hats.get(activeHat ?? "");
    if (!hatDesc) {
      delete event.systemPromptOptions.sections[SECTION];
    } else {
      event.systemPromptOptions.sections[SECTION] = hatDesc;
    }
  });

  pi.registerCommand("hat", {
    description: `Select a session hat: /hat [${[...hats.keys(), "off"].join("|")}]`,
    getArgumentCompletions: (prefix) => {
      const items = [...hats.keys(), "off"]
        .filter((name) => name.startsWith(prefix))
        .map((name) => ({ value: name, label: name }));
      return items.length ? items : null;
    },
    handler: async (args, ctx) => {
      let selection = args.trim();
      if (!selection) {
        const picked = await ctx.ui.select(`Select a hat (current: ${activeHat ?? "off"})`, [
          ...hats.keys(), "off",
        ]);
        if (picked === undefined) return;
        selection = picked;
      }

      if (selection !== "off" && !hats.has(selection)) {
        ctx.ui.notify(`Unknown hat "${selection}". Choices: ${[...hats.keys(), "off"].join(", ")}`, "error");
        return;
      }
      activeHat = selection === "off" ? null : selection;
      pi.appendEntry(STATE_TYPE, { hat: activeHat });
      updateStatus(ctx);
      ctx.ui.notify(`Hat: ${activeHat ?? "off"}. Applies to your next message.`, "info");
    },
  });
}
