{ lib, osConfig, ... }:

{
  config.programs.prismlauncher = lib.mkIf (osConfig.networking.hostName == "ridley") {
    config.java.mem = {
      min = 4096;
      max = 32768;
    };

    instances.main.minecraft = {
      version = "26.3";
      settings = {
        version = 5023;
        ao = true;
        autoJump = false;
        autoSuggestions = true;
        biomeBlendRadius = 7;
        chatColors = true;
        chatLinks = true;
        chatLinksPrompt = true;
        chunkSectionFadeInTime = 0.4;
        cloudRange = 128;
        cutoutLeaves = true;
        darknessEffectScale = 1.0;
        discrete_mouse_scroll = false;
        enableVsync = false;
        entityDistanceScaling = 1.25;
        entityShadows = true;
        exclusiveFullscreen = true;
        forceUnicodeFont = false;
        fov = -0.25;
        fovEffectScale = 1.0;
        fullscreen = true;
        gamma = 0.5089609925176056;
        glintSpeed = 0.5;
        glintStrength = 0.75;
        graphicsPreset = "custom";
        guiScale = 4;
        improvedTransparency = true;
        inactivityFpsLimit = "afk";
        invertXMouse = false;
        invertYMouse = false;
        japaneseGlyphVariants = false;
        macFullscreenMenuVisibility = false;
        maxAnisotropyBit = 3;
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
        renderDistance = 32;
        rotateWithMinecart = true;
        screenEffectScale = 1.0;
        showSubtitles = false;
        simulationDistance = 32;
        textureFiltering = 2;
        vignette = true;
        weatherRadius = 10;
      };
    };
  };
}
