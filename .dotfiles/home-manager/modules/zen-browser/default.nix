{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  cfg = config.trident.zen-browser;
in {
  options.trident.zen-browser = {
    enable = lib.mkEnableOption "activate zen-browser";
  };

  config = lib.mkIf cfg.enable {
    programs.zen-browser = {
      enable = true;
      nativeMessagingHosts = [pkgs.firefoxpwa];
      profiles.trident = {
        search.force = true;
        search.engines = {
          "Nix Packages" = {
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = ["@np"];
          };
          "Nix Options" = {
            urls = [
              {
                template = "https://search.nixos.org/options";
                params = [
                  {
                    name = "type";
                    value = "options";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];

            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = ["@no"];
          };
          "HomeManager Options" = {
            urls = [
              {
                template = "https://home-manager-options.extranix.com/";
                params = [
                  {
                    name = "type";
                    value = "options";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];

            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = ["@hm"];
          };
          "Rust packages" = {
            urls = [
              {
                template = "https://lib.rs/search";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            definedAliases = ["@rs"];
          };
        };
        extensions.packages = with inputs.firefox-addons.packages."x86_64-linux"; [
          ublock-origin
          sponsorblock
          privacy-badger
          decentraleyes
        ];
        extraConfig = ''
                 // --- Existing Preferences ---
                 user_pref("extensions.autoDisableScopes", 0);
                 user_pref("extensions.enabledScopes", 15);

                 // --- Privacy Settings (Examples) ---
                 // History: Clear history when Firefox closes
                 user_pref("privacy.sanitize.sanitizeOnShutdown", false);
                 // What to clear when Firefox closes (adjust based on about:config -> privacy.sanitize.details)
                 user_pref("privacy.sanitize.historyPasswords", false);
                 user_pref("privacy.sanitize.history", true);
                 user_pref("privacy.sanitize.formdata", true);
                 user_pref("privacy.sanitize.cache", true);
                 user_pref("privacy.sanitize.offlineApps", true);
                 user_pref("privacy.sanitize.sessions", false);
                 user_pref("privacy.sanitize.downloads", false);

                 // Do Not Track
                 user_pref("privacy.donottrackheader.enabled", true);

                 // Cookies: Block third-party cookies (most common privacy setting)
                 // 0: Accept all, 1: Accept from originating site, 2: Block all, 3: Block unvisited 3rd party
                 user_pref("network.cookie.cookieBehavior", 3);

                 // Prevent accessibility services from accessing your browser
                 user_pref("accessibility.accessiblerendering", false);

                 // --- Download Settings (Examples) ---
                 // Default download directory (use absolute path)
                 user_pref("browser.download.dir", "${config.home.homeDirectory}/Downloads");
                 // Ask where to save every file (true) or use default download directory (false)
                 user_pref("browser.download.useDownloadDir", true);
                 // Download directory for specific MIME types (more advanced)

                 // Default action for certain file types (e.g., always save PDFs)
                 // 0: Ask every time, 1: Save file, 2: Open with default application, 3: Use helper application
                 // user_pref("browser.helperApps.neverAsk.saveToDisk", "application/octet-stream,application/pdf"); // Example: Always save unknown binary files and PDFs

                 // --- Other Settings Menu Examples ---
                 // Restore previous session on startup (0: Blank, 1: Home page, 2: Last session, 3: Resume previous session)
                 user_pref("browser.startup.page", 3);
                 // Show the home button on the toolbar
                 user_pref("browser.show novice tips", false); // This specific pref controls a lot of UI tips

                 user_pref("extensions.autoDisableScopes", 0);

          user_pref("xpinstall.signatures.required", false)

                 user_pref("zen.view.compact.hide-toolbar",true)
                 user_pref("zen.view.compact.hide-tabbar", true)
                 user_pref("browser.compactmode.show", true)
                 user_pref("sidebar.visibility",false)

                 user_pref("zen.theme.acrylic-elements",true)
                 user_pref"zen.theme.accent-color","#ffb787")
                 user_pref("zen.widget.linux.transparency", true)

                 user_pref("browser.aboutConfig.showWarning",false)

                 user_pref("extensions.enabledScopes", 15);
                 user_pref("zen.keyboard.shortcuts.version", 9);
                 user_pref("zen.migration.version", 1);
                 user_pref("zen.view.compact.hide-toolbar", true);
                 user_pref("zen.view.show-newtab-button-border-top", true);
                 user_pref("zen.view.use-single-toolbar", false);
                 user_pref("zen.welcome-screen.seen", true);
        '';
      };
    };
  };
}
