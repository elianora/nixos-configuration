{ ... }:

{
  config = {
    home-manager.sharedModules = [
      ({ config, lib, pkgs, ... }: {
        options.software.development-tools.editors.rider.enable = lib.mkEnableOption "Enable Rider integrated development environment";
        config = lib.mkIf config.software.development-tools.editors.rider.enable {
          assertions = [
            {
              assertion = config.software.desktop-environments.plasma.enable;
              message = "A desktop environment is required to enable Rider";
            }
            {
              assertion = config.software.development-tools.languages.dotnet.enable;
              message = ".NET language support is required to enable Rider";
            }
          ];

          home.packages = with pkgs; [
            (jetbrains.rider.overrideAttrs (attrs: {
              version = "2026.3.0.2";
              buildNumber = "263.7307.355";
              src = fetchurl {
                url = "https://download.jetbrains.com/rider/JetBrains.Rider-2026.3.0.2.tar.gz";
                hash = "sha256-0+hDE1lw1IxYAzaQIpv1llSXq1seEbrBuecHQyMiA7c=";
              };

              # The debugger agent runs on Android, where liblog.so is provided by the OS.
              autoPatchelfIgnoreMissingDeps = lib.optionals stdenv.hostPlatform.isLinux [ "liblog.so" ];
              postInstall = (attrs.postInstall or "") + lib.optionalString stdenv.hostPlatform.isLinux ''
                # Azure Artifacts authentication only enables the MSAL broker on Windows.
                rm -f "$out/rider/lib/ReSharperHost/linux-x64/libmsalruntime.so" \
                      "$out/rider/lib/ReSharperHost/runtimes/linux-x64/native/libmsalruntime.so"
              '';
            }))
          ];
        };
      })
    ];

    # NOTE: This is a temporary workaround!
    nixpkgs.config.permittedInsecurePackages = [
      "rider-2026.3.0.2"
    ];
  };
}
