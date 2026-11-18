{ ... }:

let
  config-file = builtins.toFile "konsolerc" ''
    [Desktop Entry]
    DefaultProfile=elianora-profile.profile

    [General]
    ConfigVersion=1

    [SaveHistory Settings]
    Recent URLs[$e]=file:$HOME/Documents

    [UiSettings]
    ColorScheme=
  '';

  profile = builtins.toFile "elianora-profile.profile" ''
    [Appearance]
    Font=Fira Code,13,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,,0,0

    [General]
    Name=elianora-profile
    Parent=FALLBACK/
  '';
in
{
  config.home.file = {
    konsolerc = {
      enable = true;
      source = "${config-file}";
      target = ".config/konsolerc";
    };

    profile = {
      enable = true;
      source = "${profile}";
      target = ".local/share/konsole/elianora-profile.profile";
    };
  };
}
