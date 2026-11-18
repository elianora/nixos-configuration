{ config, lib, ... }:

{
  options.hardware.nvidia.driver.enable = lib.mkEnableOption "Enable the NVIDIA driver";
  config.hardware.nvidia = lib.mkIf config.hardware.nvidia.driver.enable {
    modesetting.enable = true;
    nvidiaSettings = true;
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "620.70.06";
      sha256_64bit = "sha256-KRGOOr0IwHVZvMo9nHYjjQOUkK8DYqLlvPy+cgSv1LE=";
      sha256_aarch64 = "sha256-P6ZaknHg3eKk5YxJZcOIhaAqOkKszcsm/IF0EGB/PgM=";
      openSha256 = "sha256-dV8vzniUl3UJoG2Q3KdoUJigLRuQeTniUfB670gb1Mw=";
      settingsSha256 = "sha256-CFBRmXFJ9eAf5BRlHMBolahz1Pshr9giI7zcZC29oZ8=";
      persistencedSha256 = "sha256-FpGzhArrvR1nEt8lKDzNEnbvHvGP36gL1dINvpDAkpA=";
    };
  };
}
