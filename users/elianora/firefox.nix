{ ... }:

{
  # SEE:
  # https://firefox-admin-docs.mozilla.org/reference/policies/
  config.programs.firefox.policies = {
    AutofillAddressEnabled = false;
    AutofillCreditCardEnabled = false;
    AIControls.Default = "blocked";
    DisableFormHistory = true;
    DisableTelemetry = true;
    ExtensionSettings = {
      "*" = {
        installation_mode = "blocked";
        blocked_install_message = "Please use your NixOS configuration to install extensions.";
      };

      "{446900e4-71c2-419f-a6a7-df9c091e268b}".installation_mode = "normal_installed"; # Bitwarden
      "{5ac8c0a3-ce21-4c47-972d-b45e685cca5d}".installation_mode = "normal_installed"; # Twitch chat pronouns
      "firefox@betterttv.net".installation_mode = "normal_installed";
      "plasma-browser-integration@kde.org".installation_mode = "normal_installed";
      "uBlock0@raymondhill.net".installation_mode = "normal_installed";
    };

    FirefoxHome = {
      Highlights = false;
      Pocket = false;
      Search = true;
      Snippets = false;
      SponsoredPocket = false;
      SponsoredStories = false;
      SponsoredTopSites = false;
      Stories = false;
      TopSites = false;
      Widgets.Enabled = false;
    };

    GenerativeAI = {
      Enabled = false;
      Chatbot = false;
      LinkPreviews = false;
      TabGroups = false;
    };

    Handlers.schemes = {
      mailto = {
        action = "useHelperApp";
        ask = false;
        handlers = [
          {
            name = "Fastmail";
            uriTemplate = "https://app.fastmail.com/mail/compose?mailto=%s";
          }
        ];
      };
    };

    Homepage = {
      NewTabOnRestore = false;
      StartPage = "none";
    };

    NewTabPage = false;
    NoDefaultBookmarks = true;
    OfferToSaveLoginsDefault = false;
    PasswordManagerEnabled = false;
    Preferences."browser.translations.automaticallyPopup" = true;
    SearchBar = "unified";
    SearchEngines = {
      Add = [
        {
          Name = "NoAI DuckDuckGo";
          URLTemplate = "https://noai.duckduckgo.com/?q={searchTerms}&noai=1";
          Method = "GET";
          IconURL = "https://duckduckgo.com/static-assets/favicons/favicon.ico";
          Alias = "noai";
          Description = "NoAI DuckDuckGo";
        }
      ];

      Default = "NoAI DuckDuckGo";
      Remove = [
        "Bing"
        "DuckDuckGo"
        "eBay"
        "Google"
        "Perplexity"
      ];
    };

    Sync = {
      Enabled = true;
      Addons = true;
      Addresses = false;
      Bookmarks = true;
      History = true;
      OpenTabs = true;
      Passwords = false;
      PaymentMethods = false;
      Settings = true;
    };

    TranslateEnabled = true;
    UserMessaging = {
      ExtensionRecommendations = false;
      FeatureRecommendations = false;
      UrlbarInterventions = false;
      MoreFromMozilla = false;
      FirefoxLabs = false;
    };

    UseSystemPrintDialog = true;
    VisualSearchEnabled = false;
  };
}
