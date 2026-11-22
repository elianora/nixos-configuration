{ inputs, pkgs, ... }:

{
  config.programs.reaper = {
    extensions = {
      reapack = {
        enable = true;
        addDefaultRepositories = true;
        browser.expandSynonyms = true;
        enablePrereleasesGlobally = false;
        installNewPackagesWhenSynchronizing = false;
        packages = [
          {
            repository = "ReaTeam Extensions";
            category = "API";
            name = "js_ReaScriptAPI.ext";
          }
          {
            repository = "BirdBird ReaScript Testing";
            category = "Global Sampler";
            name = "BirdBird_Global Sampler.lua";
          }
          {
            repository = "ReaTeam Scripts";
            category = "Items Editing";
            name = "amagalma_Smart Crossfade.lua";
          }
          {
            repository = "ReaTeam Scripts";
            category = "MIDI Editor";
            name = "js_Mouse editing - Draw ramp.lua";
          }
          {
            repository = "ReaTeam Scripts";
            category = "MIDI Editor";
            name = "js_Mouse editing - Multi tool.lua";
          }
          {
            repository = "ReaTeam Scripts";
            category = "MIDI Editor";
            name = "js_LFO Tool (MIDI editor version, insert CCs in time selection in lane under mouse).lua";
          }
          {
            repository = "ReaTeam Scripts";
            category = "Rendering";
            name = "cfillion_Apply render preset.lua";
          }
          {
            repository = "ReaTeam Scripts";
            category = "Various";
            name = "amagalma_Smart contextual zoom.lua";
          }
          {
            repository = "ReaTeam Scripts";
            category = "Various";
            name = "pandabot_ChordGun.lua";
          }
          {
            repository = "ReaTeam Scripts";
            category = "Various";
            name = "rodilab_Smart select all (depending on focus, tracks selected and time selection).lua";
          }
        ];

        promptToUninstallObsoletePackages = true;
        repositories = [
          {
            name = "BirdBird ReaScript Testing";
            url = "https://raw.githubusercontent.com/Bird-Bird/ReaScript_Testing/main/index.xml";
            installNewPackages = "manual";
          }
        ];

        synchronizeOnActivation = true;
      };

      sws.enable = true;
    };

    preferences = {
      general = {
        advancedUiSystemTweaks = {
          uiScale = 1.25;
          fontSizeAdjustment = 1.25;
          allowSnapGridRoutingWindowsToStayOpen = true;
          allowKeyboardCommandsEvenWhenMouseEditing = true;
        };

        startupSettings.showSplashScreenOnStartup = false;
      };

      plugIns.reascript.python.enable = true;
    };

    swell.colortheme = {
      enable = true;
      preset = inputs.reaper-flake.packages.${pkgs.stdenv.hostPlatform.system}.reapertips-theme;
    };

    theme = {
      active = "Reapertips Theme.ReaperThemeZip";
      colorThemes = [];
      packages = [
        inputs.reaper-flake.packages.${pkgs.stdenv.hostPlatform.system}.reapertips-theme
      ];
    };
  };
}
