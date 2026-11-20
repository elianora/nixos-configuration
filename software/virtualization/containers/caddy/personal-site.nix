{ config, lib, pkgs, ... }:

let
  any-user-has-caddy-enabled = builtins.any (user: config.home-manager.users.${user}.software.virtualization.containers.caddy.enable) (builtins.attrNames config.home-manager.users);
in
{
  options.custom-packages.personal-site = lib.mkOption {
    description = "Personal site of Elianora Rose";
    type = lib.types.attrs;
  };

  config.custom-packages.personal-site = lib.mkIf any-user-has-caddy-enabled (pkgs.stdenv.mkDerivation {
    name = "personal-site";
    src = pkgs.fetchFromGitHub {
      owner = "elianora";
      repo = "personal-site";
      rev = "54640ca012f995d8ad01c2deec4727dbb5e57607";
      hash = "sha256-nYNGzGJDukWboBLbnVQegM4PkKOP9esGDuRdkU4txYo=";
    };

    nativeBuildInputs = with pkgs; [
      bundler
      bundix
      jekyll
      ruby.devEnv
    ];

    installPhase = ''
      export JEKYLL_ENV=production
      mkdir vendor
      ${pkgs.bundler}/bin/bundle config set path vendor
      ${pkgs.bundler}/bin/bundle config set --local force_ruby_platform true
      ${pkgs.bundler}/bin/bundle cache
      ${pkgs.bundix}/bin/bundix
      ${pkgs.bundler}/bin/bundler exec jekyll build --destination $out
      rm -rf vendor
    '';
  });
}
