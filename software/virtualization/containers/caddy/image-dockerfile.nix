{ ... }:

{
  config.home-manager.sharedModules = [
    ({ config, lib, ... }: {
      options.software.virtualization.containers.caddy.dockerfile = lib.mkOption {
        description = "Caddy dockerfile";
        type = lib.types.package;
      };

      config.software.virtualization.containers.caddy.dockerfile = lib.mkIf config.software.virtualization.containers.caddy.enable (builtins.toFile "Dockerfile.caddy" ''
        FROM caddy:${config.software.virtualization.containers.caddy.version}-builder AS builder
        RUN xcaddy build \
          --with github.com/liujed/caddy-dns01proxy \
          --with github.com/caddy-dns/porkbun

        FROM caddy:${config.software.virtualization.containers.caddy.version}
        COPY --from=builder /usr/bin/caddy /usr/bin/caddy
      '');
    })
  ];
}
