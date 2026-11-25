{ ... }:

{
  config.home-manager.sharedModules = [
    ({ config, lib, pkgs, ... }: {
      options.software.games.minecraft.enable = lib.mkEnableOption "Enable Minecraft via Prism launcher";
      config = lib.mkIf config.software.games.minecraft.enable {
        assertions = [
          {
            assertion = config.software.desktop-environments.plasma.enable;
            message = "A desktop environment is required to enable Minecraft via Prism launcher";
          }
        ];

        programs.prismlauncher = {
          enable = true;
          config.java = {
            mem = {
              min = 4096;
              max = 32768;
            };

            path = "${pkgs.jdk25}/bin/java";
          };

          instances.main.minecraft = {
            version = "26.3";
            settings = {
              version = 5023;
              ao = true;
              biomeBlendRadius = 7;
              chunkSectionFadeInTime = 0.4;
              cutoutLeaves = true;
              enableVsync = false;
              entityDistanceScaling = 1.25;
              entityShadows = true;
              forceUnicodeFont = false;
              japaneseGlyphVariants = false;
              fov = -0.25;
              fovEffectScale = 1.0;
              darknessEffectScale = 1.0;
              glintSpeed = 0.5;
              glintStrength = 0.75;
              preferredGraphicsBackend = "default";
              graphicsPreset = "custom";
              prioritizeChunkUpdates = 1;
              fullscreen = true;
              exclusiveFullscreen = true;
              macFullscreenMenuVisibility = false;
              gamma = 0.5089609925176056;
              guiScale = 4;
              maxAnisotropyBit = 3;
              textureFiltering = 2;
              maxFps = 120;
              improvedTransparency = true;
              inactivityFpsLimit = "afk";
              mipmapLevels = 4;
              narrator = 0;
              particles = 0;
              reducedDebugInfo = false;
              renderClouds = "true";
              cloudRange = 128;
              renderDistance = 32;
              simulationDistance = 32;
              screenEffectScale = 1.0;
              vignette = true;
              weatherRadius = 10;
              autoJump = false;
              rotateWithMinecart = true;
              operatorItemsTab = false;
              autoSuggestions = true;
              chatColors = true;
              chatLinks = true;
              chatLinksPrompt = true;
              discrete_mouse_scroll = false;
              invertXMouse = false;
              invertYMouse = false;
              realmsNotifications = true;
              showSubtitles = false;
            };
          };
        };
      };
    })
  ];
}
