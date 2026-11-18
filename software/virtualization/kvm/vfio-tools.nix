{ lib, pkgs, ... }:

{
  options.custom-packages.vfio-tools = lib.mkOption {
    description = "VFIO Tools";
    type = lib.types.package;
  };

  config.custom-packages.vfio-tools = pkgs.stdenvNoCC.mkDerivation {
    pname = "vfio-tools";
    version = "1.0.0";
    src = pkgs.fetchFromGitHub {
      hash = "sha256-0e7S49GYMN/Ir1ftbCWw9y7J3fENcb281Y8/PgcYW9s=";
      owner = "PassthroughPOST";
      repo = "VFIO-Tools";
      rev = "0e50fd12ece4defba7660b1f2012f9759649ec11";
    };

    installPhase = ''
      runHook preInstall
      mkdir -p $out/{bin,hooks}
      cp $src/vfioselect/vfioselect $out/bin/vfioselect
      cp $src/libvirt_hooks/qemu $out/bin/qemu
      cp $src/libvirt_hooks/hooks/* $out/hooks/
      runHook postInstall
    '';
  };
}

