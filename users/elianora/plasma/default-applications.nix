{ config, lib, ... }:

{
  # NOTES:
  # Common file types found via the following command in the home dir:
  # find ~ -type f -exec xdg-mime query filetype {} \; | sort | uniq
  #
  # Scheme handlers:
  # - x-scheme-handler/about
  # - x-scheme-handler/http
  # - x-scheme-handler/https
  # - x-scheme-handler/mailto
  # - x-scheme-handler/unknown
  #
  # File types:
  # - application/gzip
  # - application/json
  # - application/pdf
  # - application/pgp-encrypted
  # - application/schema+json
  # - application/vnd.apple.keynote
  # - application/vnd.microsoft.portable-executable
  # - application/vnd.ms-publisher
  # - application/vnd.sqlite3
  # - application/x-desktop
  # - application/x-executable
  # - application/x-java-pack200
  # - application/x-msdownload
  # - application/x-perl
  # - application/x-sharedlib
  # - application/x-shellscript
  # - application/x-trash
  # - application/x-troff-man
  # - application/x-x509-ca-cert
  # - application/x-zerosize (this is Nix .nix files)
  # - application/xml
  # - application/yaml
  # - audio/x-mod
  # - font/otf
  # - image/gif
  # - image/jpeg
  # - image/jpeg
  # - image/png
  # - image/png
  # - image/svg+xml
  # - image/svg+xml
  # - image/vnd.microsoft.icon
  # - image/x-tga
  # - inode/fifo
  # - text/css
  # - text/html
  # - text/javascript
  # - text/markdown
  # - text/plain
  # - text/rust
  # - text/vnd.trolltech.linguist (this is TypeScript .ts files)
  # - text/x-c++src
  # - text/x-csrc
  # - text/x-devicetree-source
  # - text/x-log
  # - text/x-python
  # - text/x-python3
  # - video/mp4
  config.xdg.mimeApps = lib.mkIf config.software.desktop-environments.plasma.enable rec {
    enable = true;
    associations.added = {
      "application/pdf" = [
        "org.kde.okular.desktop"
        "firefox.desktop"
      ];

      "application/schema+json" = "codium.desktop";
      "application/x-perl" = "codium.desktop";
      "application/x-zerosize" = "codium.desktop";
      "application/xml" = "codium.desktop";
      "application/yaml" = "codium.desktop";
      "text/css" = "codium.desktop";
      "text/html" = "codium.desktop";
      "text/javascript" = "codium.desktop";
      "text/markdown" = "codium.desktop";
      "text/plain" = "codium.desktop";
      "text/rust" = "codium.desktop";
      "text/x-c++src" = "codium.desktop";
      "text/x-csrc" = "codium.desktop";
      "text/x-log" = "codium.desktop";
      "text/x-python" = "codium.desktop";
      "text/x-python3"= "codium.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/mailto" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
    };

    defaultApplications = associations.added;
  };
}
