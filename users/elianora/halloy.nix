{ ... }:

{
  config.programs.halloy = {
    settings = {
      font = {
        family = "Fira Code";
        size = 21;
      };

      servers.nya-lgbt = {
        nickname = "elianora";
        server = "irc.nya.lgbt";
        use_tls = true;
        port = 6697;
        channels = [
          "#general"
          "#furry-rp-chat"
          "#grumpy-yapping"
          "#xmpp-evangelism-and-testing"
        ];
      };

      theme = "dracula";
    };

    themes.dracula = {
      general = {
        background = "#282A36";
        border = "#44475A";
        horizontal_rule = "#44475A50";
        unread_indicator = "#BD93F9";
      };

      text = {
        primary = "#F8F8F2";
        secondary = "#44475A";
        tertiary = "#BD93FA";
        success = "#50FA7B";
        error = "#FF5555";
      };

      buffer = {
        action = "#FFB86C";
        background = "#1F222D";
        background_text_input = "#1A1B24";
        background_title_bar = "#1A1B24";
        border = "#00000000";
        border_selected = "#50FA7B";
        code = "#FF79C6";
        highlight = "#2B2E3A";
        nickname = "#FF79C6";
        selection = "#353947";
        timestamp = "#919293";
        topic = "#C0C1BF";
        url = "#8BE9FD";
      };

      "buffer.server_messages".default = "#F1FA8C";
      "buttons.primary" = {
        background = "#282A36";
        background_hover = "#404145";
        background_selected = "#3D3D51";
        background_selected_hover = "#404145";
      };

      "buttons.secondary" = {
        background = "#2B2E3A";
        background_hover = "#404145";
        background_selected = "#3B364E";
        background_selected_hover = "#404145";
      };
    };
  };
}
