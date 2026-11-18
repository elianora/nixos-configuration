{ ... }:

{
  config = {
    display-name = "Podman Manager";
    home.uid = 1002;
    service-user = true;
    software = {
      core = {
        eza.enable = true;
        starship.enable = true;
        tmux.enable = true;
      };

      development-tools.editors.helix.enable = true;
      virtualization.containers = {
        enable = true;
        caddy.enable = true;
        jellyfin.enable = true;
        navidrome.enable = true;
      };
    };

    sudoer = false;
  };
}
