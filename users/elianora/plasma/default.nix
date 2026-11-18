{ config, lib, ... }:

{
  imports = [
    ./default-applications.nix
    ./fonts.nix
    ./inputs.nix
    ./keyboard-shortcuts.nix
    ./panels.nix
    ./search.nix
  ];

  config = rec {
    home.file = {
      ".face.icon" = {
        enable = true;
        source = ../assets/elianora.png;
        target = ".face.icon"; # NOTE: This is a special plasma icon value that sets the profile pic
      };

      ".wallpaper.jpg" = rec {
        enable = builtins.pathExists ../assets/gridania.jpg;
        source = lib.mkIf enable ../assets/gridania.jpg;
        target = lib.mkIf enable ".wallpaper.jpg";
      };
    };

    programs.plasma = lib.mkIf config.software.desktop-environments.plasma.enable {
      # NOTE:
      # Settings not captured by plasma-manager currently
      configFile = {
        kdeglobals = {
          KScreen = {
            ScreenScaleFactors = "eDP-1=1";
            XwaylandClientsScale = false;
          };
        };

        kscreenlockerrc.Daemon = {
          LockGrace = 60;
          Timeout = 30;
        };
      };

      desktop.widgets = [];

      session = {
        general = {
          askForConfirmationOnLogout = false;
        };

        sessionRestore = {
          restoreOpenApplicationsOnLogin = "startWithEmptySession";
        };
      };

      workspace = {
        clickItemTo = "select";
        colorScheme = "BreezeDark";
        splashScreen = {
          engine = "KSplashQML";
          theme = "org.kde.breeze.desktop";
        };

        theme = "breeze-dark";
        wallpaper = lib.mkIf home.file.".wallpaper.jpg".enable "/home/${config.home.username}/${home.file.".wallpaper.jpg".target.content}";
        windowDecorations = {
          library = "org.kde.breeze";
          theme = "Breeze";
        };
      };
    };
  };
}
