{ lib, ... }:

{
  imports = [
    ./containers
    ./kvm
  ];

  options.software.virtualization.cpu-type = lib.mkOption {
    description = ''The CPU type ("amd" or "intel")'';
    type = lib.types.enum [
      "amd"
      "intel"
    ];
  };
}
