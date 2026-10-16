const fs = require("fs");
const path = require("path");
const vscode = require("vscode");

const THEMES = ["Rosewood Dark", "Rosewood Light", "Rosewood Black"];
const FALLBACK = {
  "Rosewood Light": "Default Light Modern",
  "Rosewood Dark": "Default Dark Modern",
  "Rosewood Black": "Default Dark Modern",
};

let watcher = null;
let retry = null;
let pending = null;

async function refreshActiveTheme() {
  const workbench = vscode.workspace.getConfiguration("workbench");
  const active = workbench.get("colorTheme");
  if (!THEMES.includes(active)) {
    return;
  }

  const autoReload = vscode.workspace
    .getConfiguration("rosewood")
    .get("autoReloadWindow", false);
  if (autoReload) {
    await vscode.commands.executeCommand("workbench.action.reloadWindow");
    return;
  }

  const flip = FALLBACK[active];
  try {
    await workbench.update("colorTheme", flip, vscode.ConfigurationTarget.Global);
    await new Promise((resolve) => setTimeout(resolve, 80));
    await workbench.update("colorTheme", active, vscode.ConfigurationTarget.Global);
  } catch (err) {
    void err;
  }
}

function scheduleRefresh() {
  if (pending) {
    clearTimeout(pending);
  }
  pending = setTimeout(() => {
    pending = null;
    refreshActiveTheme();
  }, 500);
}

function startWatch(themesDir) {
  if (watcher) {
    return;
  }
  try {
    watcher = fs.watch(themesDir, { persistent: false }, (event, file) => {
      if (!file || file.endsWith(".json")) {
        scheduleRefresh();
      }
    });
  } catch (err) {
    void err;
    retry = setTimeout(() => startWatch(themesDir), 5000);
  }
}

function activate(context) {
  const themesDir = path.join(context.extensionPath, "themes");

  if (fs.existsSync(themesDir)) {
    startWatch(themesDir);
  } else {
    retry = setTimeout(() => startWatch(themesDir), 5000);
  }

  context.subscriptions.push(
    vscode.commands.registerCommand("rosewood.reloadTheme", refreshActiveTheme),
    {
      dispose() {
        if (watcher) {
          watcher.close();
          watcher = null;
        }
        if (retry) {
          clearTimeout(retry);
          retry = null;
        }
        if (pending) {
          clearTimeout(pending);
          pending = null;
        }
      },
    }
  );
}

function deactivate() {
  if (watcher) {
    watcher.close();
    watcher = null;
  }
  if (retry) {
    clearTimeout(retry);
    retry = null;
  }
}

module.exports = { activate, deactivate };
