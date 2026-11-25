{ ... }:

{
  config = {
    programs.git.enable = true;
    home-manager.sharedModules = [
      ({ config, lib, ... }: {
        options.software.core.git = {
          enable = lib.mkEnableOption "Enable git";
          email = lib.mkOption {
            description = "The email of the git user";
            type = lib.types.str;
          };

          name = lib.mkOption {
            description = "The full name of the git user";
            type = lib.types.str;
          };
        };

        config.programs.git = lib.mkIf config.software.core.git.enable {
          enable = true;
          lfs.enable = true;
          settings = lib.mergeAttrs {
            user = {
              email = config.software.core.git.email;
              name = config.software.core.git.name;
            };
          } (lib.optionalAttrs config.software.development-tools.editors.codium.enable {
            core = {
              editor = "codium --wait";
            };

            diff = {
              tool = "codium";
            };

            difftool = {
              prompt = false;
            };

            "difftool \"codium\"" = {
              cmd = "codium --wait --diff $LOCAL $REMOTE";
            };

            merge = {
              tool = "codium";
            };

            "mergetool \"codium\"" = {
              cmd = "codium --wait --merge $REMOTE $LOCAL $BASE $MERGED";
            };
          });
        };
      })
    ];
  };
}
