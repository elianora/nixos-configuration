{ config, lib, ... }:

{
  config.programs.plasma.panels = lib.mkIf config.software.desktop-environments.plasma.enable [
    {
      alignment = "center";
      floating = false;
      height = 52;
      hiding = "none";
      lengthMode = "fill";
      location = "bottom";
      opacity = "opaque";
      screen = "all";
      widgets = [
        {
          kickoff = {
            applicationsDisplayMode = "list";
            compactDisplayStyle = true;
            favoritesDisplayMode = "list";
            icon = "nix-snowflake-white";
            showActionButtonCaptions = true;
            showButtonsFor = "powerAndSession";
            sidebarPosition = "left";
            sortAlphabetically = true;
          };
        }
        {
          iconTasks = {
            appearance = {
              fill = true;
              highlightWindows = true;
              iconSpacing = "medium";
              indicateAudioStreams = true;
              rows = {
                maximum = 1;
                multirowView = "never";
              };

              showTooltips = true;
            };

            behavior = {
              grouping = {
                clickAction = "cycle";
                method = "byProgramName";
              };

              middleClickAction = "none";
              minimizeActiveTaskOnClick = true;
              newTasksAppearOn = "right";
              showTasks = {
                onlyInCurrentScreen = false;
                onlyInCurrentDesktop = false;
                onlyInCurrentActivity = false;
                onlyMinimized = false;
              };

              sortingMethod = "manually";
              unhideOnAttentionNeeded = true;
              wheel = {
                switchBetweenTasks = false;
                ignoreMinimizedTasks = false;
              };
            };

            iconsOnly = true;
            launchers = [
              "applications:firefox.desktop"
              "applications:discord.desktop"
              "applications:codium.desktop"
              "applications:md.obsidian.Obsidian.desktop"
              "applications:org.kde.dolphin.desktop"
              "applications:org.kde.konsole.desktop"
            ];
          };
        }
        {
          systemTray = {
            icons = {
              scaleToFit = false;
              spacing = "medium";
            };

            items.showAll = false;
          };
        }
        {
          digitalClock = {
            calendar = {
              firstDayOfWeek = "sunday";
              showWeekNumbers = false;
            };

            date = {
              enable = true;
              format = "shortDate";
              position = "belowTime";
            };

            font = {
              family = "DejaVu Sans";
              size = 11;
              style = "normal";
            };

            time = {
              format = "12h";
              showSeconds = "onlyInTooltip";
            };

            timeZone = {
              changeOnScroll = false;
              format = "offset";
            };
          };
        }
      ];
    }
  ];
}
