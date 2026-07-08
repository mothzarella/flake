{
  flake.modules.homeManager.browsers = {
    programs.firefox = {
      enable = true;

      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        NoDefaultBookmarks = true;
        EnableTrackingProtection = {
          Value = true;
          Cryptomining = true;
          Fingerprinting = true;
        };

        ExtensionSettings = {
          # uBlock Origin
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
          };

          # Mullvad Browser Extension
          "{d19a89b9-76c1-4a61-bcd4-49e8de916403}" = {
            install_url = "https://github.com/mullvad/browser-extension/releases/download/v0.9.10-firefox-beta/mullvad-browser-extension-0.9.10.xpi";
            installation_mode = "force_installed";
          };
        };
      };

      profiles.default = {
        isDefault = true;
        settings = {
          "browser.contentblocking.category" = "strict";
          "privacy.donottrackheader.enabled" = true;
          "dom.security.https_only_mode" = true;

          "gfx.webrender.all" = true;
          "media.ffmpeg.vaapi.enabled" = true;
          "browser.tabs.unloadOnLowMemory" = true;
        };
      };
    };

    persistence.directories = [".mozilla/firefox"];
  };
}
