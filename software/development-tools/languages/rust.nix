{ ... }:

{
  config.home-manager.sharedModules = [
    ({ config, lib, pkgs, ... }: {
      options.software.development-tools.languages.rust.enable = lib.mkEnableOption "Enable Rust language support and tooling";
      config.home.packages = lib.optional config.software.development-tools.languages.rust.enable (pkgs.rust-bin.stable.latest.default.override {
        extensions = [
          "rust-analyzer"
          "rust-src"
          "rustfmt"
        ];

        targets = [
          "x86_64-pc-windows-gnu"
          "x86_64-pc-windows-msvc"
          "x86_64-unknown-linux-gnu"
        ];
      });
    })
  ];
}
