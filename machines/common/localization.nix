{ config, lib, ... }:

{
  options.localization = {
    locale = lib.mkOption {
      description = "The language and encoding of the machine (i.e. \"en_US.UTF-8\"";
      type = lib.types.str;
    };

    timeZone = lib.mkOption {
      description = "The timezone the machine resides in";
      type = lib.types.str;
    };
  };

  config = {
    i18n = {
      defaultLocale = config.localization.locale;
      extraLocaleSettings = {
        LC_ADDRESS = config.localization.locale;
        LC_IDENTIFICATION = config.localization.locale;
        LC_MEASUREMENT = config.localization.locale;
        LC_MONETARY = config.localization.locale;
        LC_NAME = config.localization.locale;
        LC_NUMERIC = config.localization.locale;
        LC_PAPER = config.localization.locale;
        LC_TELEPHONE = config.localization.locale;
        LC_TIME = config.localization.locale;
      };
    };

    time.timeZone = config.localization.timeZone;
  };
}
