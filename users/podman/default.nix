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

    ssh-authorized-keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC3Lh9wdKK2j6kIuq7QQaeY6TKYUGu4nRniaB0S93dah personal@elianorarose.com"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIMydkK5yZgr5Atb/dT67ZlH9DlrWcz9Q6sXXvNXA0a9 elianora@ridley"
    ];

    sudoer = false;
  };
}
