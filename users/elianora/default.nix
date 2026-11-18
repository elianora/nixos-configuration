{ osConfig, ... }:

{
  imports = [
    ./codium.nix
    ./firefox.nix
    ./halloy.nix
    ./konsole.nix
    ./plasma
  ];

  config = {
    display-name = "Elianora Rose";
    home.uid = 1000;
    software = {
      browsers = {
        firefox.enable = !osConfig.headless;
        vivaldi.enable = !osConfig.headless;
      };

      core = {
        compression-utils.enable = true;
        efibootmgr.enable = true;
        eza.enable = true;
        fastfetch.enable = true;
        git = {
          enable = true;
          email = "developer@elianorarose.com";
          name = "Elianora Rose";
        };

        gnupg.enable = true;
        jq.enable = true;
        nix-utils.enable = true;
        search-utils.enable = true;
        starship.enable = true;
        system-monitoring-utils.enable = true;
        text-utils.enable = true;
        tmux.enable = true;
        wget.enable = true;
        yq.enable = true;
      };

      desktop-environments.plasma = {
        enable = !osConfig.headless;
        kde-connect.enable = !osConfig.headless;
      };

      development-tools = {
        editors = {
          codium.enable = !osConfig.headless;
          helix.enable = true;
          rider.enable = !osConfig.headless;
        };

        languages = {
          cpp.enable = true;
          dotnet.enable = true;
          nix.enable = true;
          node.enable = true;
          python.enable = true;
          ruby.enable = true;
          rust.enable = true;
        };
      };

      filesystems.gparted.enable = !osConfig.headless;
      fonts = {
        dejavu.enable = true;
        fira-code.enable = true;
        liberation.enable = true;
        powerline.enable = true;
      };

      messengers = {
        discord.enable = !osConfig.headless;
        halloy.enable = !osConfig.headless;
      };

      misc.zint.enable = !osConfig.headless;
      multimedia = {
        beets.enable = true;
        kdenlive.enable = !osConfig.headless;
        krita.enable = !osConfig.headless;
        vlc.enable = !osConfig.headless;
      };

      networking.winbox.enable = !osConfig.headless;
      office-and-notes = {
        libreoffice.enable = !osConfig.headless;
        obsidian.enable = !osConfig.headless;
      };

      recording-and-streaming = {
        obs-studio.enable = osConfig.recording.has-capture-card && !osConfig.headless;
        open-deck.enable = osConfig.recording.has-stream-deck && !osConfig.headless;
        tenacity.enable = osConfig.audio.has-recording-device && !osConfig.headless;
      };
    };
  };
}
