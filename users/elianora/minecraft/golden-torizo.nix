{ lib, osConfig, ... }:

{
  config.programs.prismlauncher = lib.mkIf (osConfig.networking.hostName == "golden-torizo") {
    config.java.mem = {
      min = 4096;
      max = 8192;
    };

    instances.main.minecraft = {
      version = "26.3";
      settings = {
        version = 5023;
        ao = true;
        autoJump = false;
        autoSuggestions = true;
        biomeBlendRadius = 3;
        chatColors = true;
        chatLinks = true;
        chatLinksPrompt = true;
        chunkSectionFadeInTime = 0.75;
        cloudRange = 64;
        cutoutLeaves = true;
        darknessEffectScale = 1.0;
        discrete_mouse_scroll = false;
        enableVsync = true;
        entityDistanceScaling = 1.0;
        entityShadows = true;
        exclusiveFullscreen = false;
        forceUnicodeFont = false;
        fov = -0.25;
        fovEffectScale = 1.0;
        fullscreen = true;
        gamma = 0.5089609925176056;
        glintSpeed = 0.5;
        glintStrength = 0.75;
        graphicsPreset = "custom";
        guiScale = 7;
        improvedTransparency = false;
        inactivityFpsLimit = "afk";
        invertXMouse = false;
        invertYMouse = false;
        japaneseGlyphVariants = false;
        macFullscreenMenuVisibility = false;
        maxAnisotropyBit = 2;
        maxFps = 120;
        mipmapLevels = 4;
        narrator = 0;
        operatorItemsTab = false;
        particles = 0;
        preferredGraphicsBackend = "default";
        prioritizeChunkUpdates = 1;
        realmsNotifications = true;
        reducedDebugInfo = false;
        renderClouds = "true";
        renderDistance = 24;
        rotateWithMinecart = true;
        screenEffectScale = 1.0;
        showSubtitles = false;
        simulationDistance = 12;
        textureFiltering = 2;
        vignette = true;
        weatherRadius = 10;
      };
    };
  };
}
