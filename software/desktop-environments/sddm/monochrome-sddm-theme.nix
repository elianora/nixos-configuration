{ lib, pkgs, ... }:

{
  options.custom-packages.monochrome-sddm-theme = lib.mkOption {
    description = "VFIO Scripts for QEMU Hooks";
    type = lib.types.package;
  };

  config.custom-packages.monochrome-sddm-theme = pkgs.stdenvNoCC.mkDerivation {
    pname = "monochrome-kde";
    version = "20240410";
    src = pkgs.fetchFromGitHub {
      owner = "pwyde";
      repo = "monochrome-kde";
      rev = "1c9983e8d1384ec2d9ff0fac59c5265fc74d0e6b";
      hash = "sha256-mnEQQ2PHzARv65PSwGDyS2bcYlRUydD5HUmVD251Tts=";
    };

    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/sddm/themes
      cp -r sddm/themes/monochrome $out/share/sddm/themes/monochrome
      runHook postInstall
    '';

    meta = {
      description = "A dark theme for the KDE Plasma desktop environment inspired by black and white photography.";
      homepage = "https://github.com/pwyde/monochrome-kde";
      license = lib.licenses.gpl3;
    };
  };
}
