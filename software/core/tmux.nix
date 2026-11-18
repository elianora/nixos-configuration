{ ... }:

{
  config.home-manager.sharedModules = [
    ({ config, lib, pkgs, ... }: {
      options.software.core.tmux.enable = lib.mkEnableOption "Enable tmux terminal multiplexer";
      config.programs = lib.mkIf config.software.core.tmux.enable {
        bash.bashrcExtra = ''
          ## Launch tmux On SSH Connect
          if [[ -n ''${PS1+x} ]] && [[ -z ''${VSCODE_IPC_HOOK_CLI+x} ]] && ! { printf '%s' "''${TERM}" | grep -q 'screen-256color\|screen' && [[ -n ''${TMUX+x} ]]; } then
              if tmux list-clients -t="$( whoami )-default-session" &> /dev/null; then
                  read -p 'An existing default Tmux session exists for you already - reattach to it? [Y/n] ' -n 1 -r && echo
              elif [[ -n ''${SSH_CLIENT+x} ]] || [[ -n ''${SSH_TTY+x} ]]; then
                  read -p 'You appear to be connecting via SSH - create a default Tmux session and attach to it? [Y/n] ' -n 1 -r && echo
              fi

              if [[ -n ''${SSH_CLIENT+x} ]] || [[ -n ''${SSH_TTY+x} ]] && [[ -z ''${REPLY+x} ]] || printf '%s' "''${REPLY}" | grep -qv '^[Nn]$'; then
                  tmux new-session -A -s "$( whoami )-default-session"
                  exit
              fi
          fi
        '';

        tmux = {
          enable = true;
          extraConfig = ''
            # Enable Mouse + Scrolling
            set -g mouse on

            # Make it so select and copy work more like a traditional terminal emulator
            bind-key -T copy-mode MouseDragEnd1Pane send-keys -X copy-pipe-no-clear pbcopy
            bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-no-clear pbcopy

            # Make editors less painful in tmux by changing keypress behavior
            setw -g xterm-keys on
            set -s escape-time 2
            set -sg repeat-time 600
            set -s focus-events on
          '';

          plugins = with pkgs; [
            {
              plugin = tmuxPlugins.dracula;
              extraConfig = ''
                set -g @dracula-plugins "cwd cpu-usage ram-usage time"
                set -g @dracula-cpu-display-load true
                set -g @dracula-refresh-rate 10
                set -g @dracula-show-edge-icons true
                set -g @dracula-show-empty-plugins false
                set -g @dracula-show-flags true
                set -g @dracula-show-left-icon "User: #{user} | Host: #H | Session: #S"
                set -g @dracula-show-powerline true
                set -g @dracula-transparent-powerline-bg false
              '';
            }
            tmuxPlugins.better-mouse-mode
          ];

          prefix = "C-a";
          shell = "${pkgs.bash}/bin/bash";
          shortcut = "a";
          terminal = "screen-256color";
        };
      };
    })
  ];
}
