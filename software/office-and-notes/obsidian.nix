{ ... }:

{
  config.home-manager.sharedModules = [
    ({ config, lib, pkgs, ... }: {
      options.software.office-and-notes.obsidian.enable = lib.mkEnableOption "Enable Obsidian markdown editor";
      config = lib.mkIf config.software.office-and-notes.obsidian.enable {
        assertions = [
          {
            assertion = config.software.desktop-environments.plasma.enable;
            message = "A desktop environment is required to enable LibreOffice";
          }
        ];

        programs.obsidian = lib.mkIf config.software.office-and-notes.obsidian.enable {
          enable = true;
          cli.enable = true;
          package = (pkgs.obsidian.overrideAttrs (final: prev: {
            nativeBuildInputs = prev.nativeBuildInputs ++ (with pkgs; [
              asar
              jq
            ]);

            postPatch = ''
              mkdir app
              asar extract ./resources/app.asar ./app
              mv ./app/package.json ./package.json.old
              jq '.desktopName = "obsidian"' ./package.json.old > ./app/package.json
              asar pack ./app ./resources/app.asar
              rm -r ./app ./package.json.old
            '';
          }));
        };
      };
    })
  ];
}
