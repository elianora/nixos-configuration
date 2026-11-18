{ config, ... }:

let
  any-user-has-dotnet-enabled = builtins.any (user: config.home-manager.users.${user}.software.development-tools.languages.dotnet.enable) (builtins.attrNames config.home-manager.users);
in
{
  config = {
    home-manager.sharedModules = [
      ({ config, lib, pkgs, ... }: let
        # NOTE:
        # This is due to the issue described in the official NixOS wiki
        # Each SDK tries to set $DOTNET_HOME, and this allows for multiple SDKs at once
        #
        # SEE:
        # https://wiki.nixos.org/wiki/DotNET#Multi-SDK_installation_with_local_workload_installation_enabled
        # https://discourse.nixos.org/t/dotnet-maui-workload/20370/10
        dotnet-combined = (with pkgs.dotnetCorePackages; combinePackages [
          aspnetcore_10_0
          aspnetcore_11_0
          sdk_10_0
          sdk_11_0
        ]).overrideAttrs (finalAttrs: previousAttrs: {
          postBuild = (previousAttrs.postBuild or "") + ''

            for i in $out/sdk/*
            do
              i=$(basename $i)
              length=$(printf "%s" "$i" | wc -c)
              substring=$(printf "%s" "$i" | cut -c 1-$(expr $length - 2))
              i="$substring""00"
              mkdir -p $out/metadata/workloads/''${i/-*}
              touch $out/metadata/workloads/''${i/-*}/userlocal
            done
          '';
        });
      in
      {
        options.software.development-tools.languages.dotnet.enable = lib.mkEnableOption "Enable .NET language support and tooling";
        config.home = lib.mkIf config.software.development-tools.languages.dotnet.enable {
          sessionVariables.DOTNET_ROOT = "${dotnet-combined}";
          packages = [ dotnet-combined ];
        };
      })
    ];

    # NOTE:
    # This is needed for native AOT compilation to be supported
    #
    # SEE:
    # https://wiki.nixos.org/wiki/DotNET#NativeAOT
    programs.nix-ld.enable = any-user-has-dotnet-enabled;
  };
}
