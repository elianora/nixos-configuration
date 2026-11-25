{ ... }:

{
  config.home-manager.sharedModules = [
    ({ config, lib, pkgs, ... }: {
      options.software.games.cockatrice.enable = lib.mkEnableOption "Enable Cockatrice";
      config = lib.mkIf config.software.games.cockatrice.enable {
        assertions = [
          {
            assertion = config.software.desktop-environments.plasma.enable;
            message = "A desktop environment is required to enable Cockatrice";
          }
        ];

        home.packages = with pkgs; [
          (stdenv.mkDerivation (finalAttrs: {
            pname = "cockatrice";
            version = "3.1.2";
            src = fetchFromGitHub {
              owner = "Cockatrice";
              repo = "Cockatrice";
              rev = "2026-10-25-Release-${finalAttrs.version}";
              sha256 = "sha256-yyvdg1PFdNnSGqXW37AebjA6sH3XadCBQI6AvdFwCPQ=";
            };

            nativeBuildInputs = [
              cmake
              qt6Packages.wrapQtAppsHook
            ];

            buildInputs = [
              protobuf
              qt6.qtbase
              qt6.qtdeclarative
              qt6.qtmultimedia
              qt6.qtshadertools
              qt6.qtsvg
              qt6.qttools
              qt6.qttranslations
              qt6.qtwebsockets
              zlib
            ];

            meta = {
              homepage = "https://github.com/Cockatrice/Cockatrice";
              description = "Cross-platform virtual tabletop for multiplayer card games";
              license = lib.licenses.gpl2Plus;
              maintainers = with lib.maintainers; [ evanjs ];
              platforms = with lib.platforms; linux;
            };
          }))
        ];
      };
    })
  ];
}
