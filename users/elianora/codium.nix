{ config, lib, pkgs, ... }:

{
  config.programs.vscodium.profiles.default = lib.mkIf config.software.development-tools.editors.codium.enable {
    extensions = with pkgs.vscode-extensions; [
      arrterian.nix-env-selector
      dracula-theme.theme-dracula
      editorconfig.editorconfig
      jnoortheen.nix-ide
      rust-lang.rust-analyzer
      tamasfe.even-better-toml
      vadimcn.vscode-lldb
      vscode-icons-team.vscode-icons
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "vs-keybindings";
        publisher = "ms-vscode";
        version = "0.2.1";
        sha256 = "sha256-NnLjx3fKldg6DSA4ssUt0Vevm1w8KnjEZTINZxqM7cA=";
      }
    ];

    userSettings = {
      "[nix]" = {
        "editor.insertSpaces" = true;
        "editor.tabSize" = 2;
      };
      "[toml]" = {
        "editor.insertSpaces" = true;
        "editor.tabSize" = 2;
      };
      "[yaml]" = {
        "editor.insertSpaces" = true;
        "editor.tabSize" = 2;
      };
      "chat.disableAIFeatures" = true;
      "debug.onTaskErrors" = "prompt";
      "diffEditor.ignoreTrimWhitespace" = false;
      "editor.autoClosingBrackets" = "beforeWhitespace";
      "editor.detectIndentation" = false;
      "editor.fontFamily" = "'Fira Code Retina', 'Fira Code', Consolas, 'Courier New', monospace";
      "editor.fontLigatures" = true;
      "editor.fontSize" = 15;
      "editor.formatOnPaste" = false;
      "editor.formatOnSave" = false;
      "editor.formatOnType" = false;
      "editor.guides.indentation" = true;
      "editor.insertSpaces" = true;
      "editor.minimap.enabled" = true;
      "editor.multiCursorModifier" = "alt";
      "editor.renderFinalNewline" = "on";
      "editor.renderWhitespace" = "all";
      "editor.rulers" = [ 120 ];
      "editor.snippetSuggestions" = "bottom";
      "editor.suggestSelection" = "first";
      "editor.useTabStops" = true;
      "editor.wordWrap" = "off";
      "explorer.compactFolders" = false;
      "files.insertFinalNewline" = true;
      "files.trimFinalNewlines" = false;
      "git.addAICoAuthor" = "off";
      "git.autofetch" = true;
      "git.openRepositoryInParentFolders" = "never";
      "js/ts.updateImportsOnFileMove.enabled" = "always";
      "lldb.suppressUpdateNotifications" = true;
      "nix.enableLanguageServer" = true;
      "nix.hiddenLanguageServerErrors" = [
        "textDocument/codeAction"
        "textDocument/definition"
        "textDocument/documentLink"
        "textDocument/documentHighlight"
        "textDocument/foldingRange"
        "textDocument/hover"
        "textDocument/inlayHint"
      ];

      "nix.serverPath" = "nixd";
      "nix.serverSettings".nixd.formatting.command = [ "nixfmt" ];
      "search.followSymlinks" = true;
      "search.quickOpen.includeHistory" = false;
      "search.useIgnoreFiles" = true;
      "security.workspace.trust.untrustedFiles" = "open";
      "telemetry.telemetryLevel" = "off";
      "terminal.integrated.defaultProfile.windows" = "PowerShell";
      "vsicons.dontShowNewVersionMessage" = true;
      "window.closeWhenEmpty" = false;
      "window.menuBarVisibility" = "toggle";
      "window.zoomPerWindow" = false;
      "window.zoomLevel" = 2;
      "workbench.colorCustomizations" = {
        "panel.background" = "#0f0b2494";
        "sideBar.background" = "#0f0929ee";
        "statusBar.background" = "#001649cc";
      };

      "workbench.colorTheme" = "Dracula Theme";
      "workbench.iconTheme" = "vscode-icons";
      "workbench.sideBar.location" = "right";
      "workbench.startupEditor" = "none";
    };
  };
}
