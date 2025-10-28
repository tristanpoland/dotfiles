{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.trident.vesktop;
in {
  options.trident.vesktop = {
    enable = lib.mkEnableOption "enable Vesktop";

    package = lib.mkPackageOption pkgs "vesktop" {
      example = "pkgs.vesktop.override { withTTS = false; }";
    };

    branch = lib.mkOption {
      type = lib.types.enum ["stable" "canary" "ptb"];
      default = "stable";
    };

    themeLinks = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [vesktop];

    home.file = {
      # Startup Window
      ".config/vesktop/settings.json".text = builtins.toJSON {
        arRPC = true;
        discordBranch = cfg.branch;
        enableMenu = false;
        firstLaunch = false;
        hardwareAcceleration = true;
        minimizeToTray = false;
        splashBackground = "rgb(49, 51, 56)";
        splashColor = "rgb(219, 222, 225)";
        staticTitle = false;
      };

      # Main App
      ".config/vesktop/settings/settings.json".text = builtins.toJSON {
        # See https://github.com/Vendicated/Vencord/blob/main/src/api/Settings.ts
        autoUpdate = false;
        winNativeTitleBar = true;
        
        autoUpdateNotification = false;
        useQuickCss = true;
        notifyAboutUpdates = false;
        enableReactDevtools = false;
        enabledThemes = [];
        themeLinks = cfg.themeLinks;

        plugins = {
          BetterFolders = {
            enabled = false;

          #  sidebar = true;
          #  sidebarAnim = true;
          #  closeAllFolders = true;
          #  closeAllHomeButton = true;
          #  closeOthers = true;
          #  forceOpen = true;
          #  keepIcons = false;
          #  # 0 = Never
          #  # 1 = Always
          #  # 2 = More than one folder expanded
          #  showFolderIcons = 1;
          };
          BetterGifPicker.enabled = true;
          BetterUploadButton.enabled = true;
          BiggerStreamPreview.enabled = true;
          CallTimer = {
            enabled = true;

            # possible values are "human" and "stopwatch"*
            # * default value
            format = "human";
          };
          Decor.enabled = true;
          Experiments = {
            enabled = true;

            toolbarDevMenu = false;
          };
          FakeNitro = {
            enabled = false;

            enableEmojiBypass = true;
            emojiSize = 48;
            transformEmojis = true;
            enableStickerBypass = true;
            stickerSize = 160;
            transformStickers = true;
            transformCompoundSentence = false;
            enableStreamQualityBypass = true;
            useHyperLinks = true;
            hyperLinkText = "{{NAME}}";
            disableEmbedPermissionCheck = false;
          };
          FavGifSearch = {
            enabled = true;

            # possible values are "url", "path" and "hostandpath"*
            # * default value
            searchOption = "hostandpath";
          };
          FixCodeblockGap.enabled = true;
          FixImagesQuality.enabled = true;
          FixYoutubeEmbeds.enabled = true;
          FriendInvites.enabled = true;
          FriendsSince.enabled = true;
          GreetStickerPicker = {
            enabled = true;

            # possible values are "Greet"* and "Message"
            # * default value
            greetMode = "Greet";
          };
          LoadingQuotes = {
            enabled = true;

            replaceEvents = true;
            enablePluginPresetQuotes = false;
            enableDiscordPresetQuotes = false;
            additionalQuotes = "Actually finish this one day you dummy!";
            additionalQuotesDelimiter = "|";
          };
          MessageClickActions = {
            enabled = true;

            enableDeleteOnClick = true;
            enableDoubleClickToEdit = true;
            enableDoubleClickToReply = true;
            requireModifier = false;
          };
          NewGuildSettings = {
            enabled = true;

            guild = true;
            # 0 = All messages
            # 1 = Only @mentions
            # 2 = Nothing
            # 3 = Server default
            messages = 1;
            everyone = true;
            role = true;
            hightlights = true;
            events = true;
            showAllChannels = true;
          };
          NoReplyMention = {
            enabled = true;

            userList = "";
            shouldPingListed = true;
            inverseShiftReply = false;
          };
          petpet.enabled = true;
          PlatformIndicators = {
            enabled = true;

            list = true;
            badges = true;
            messages = true;
            colorMobileIndicator = true;
          };
          RoleColorEverywhere = {
            enabled = true;

            chatMention = true;
            memberList = true;
            voiceUsers = true;
            reactorsList = true;
            pollResults = true;
            colorChatMessages = false;
            messageSaturation = 30;
          };
          SecretRingToneEnabler = {
            enabled = false;

            onlySnow = false;
          };
          ShikiCodeblocks = {
            enabled = true;

            # Specific set of theme json file urls most of all under shiki repo
            # See for more details: https://github.com/Vendicated/Vencord/blob/main/src/plugins/shikiCodeblocks.desktop/api/themes.ts
            # customTheme works the same but isn't as restrictive, therefore I will never use this
            # theme = "Monokai";
            # Just like `theme`, needs to point to raw json
            # customTheme = "https://raw.githubusercontent.com/shikijs/textmate-grammars-themes/refs/heads/main/packages/tm-themes/themes/monokai.json";

            # Valid values are "ALWAYS", "PRIMARY", "SECONDARY"* and "NEVER"
            # * default value
            tryHljs = "SECONDARY";
            # Valid values are "DISABLED", "GREYSCALE"* and "COLOR"
            # * default value
            useDevIcon = "COLOR";
            bgOpacity = 100;
          };
          ShowAllMessageButtons.enabled = true;
          SpotifyShareCommands.enabled = true;
          ValidReply.enabled = true;
          ValidUser.enabled = true;
          VolumeBooster = {
            enabled = true;

            # Int from 1-5, maps to 100%-500% max volume
            multiplier = 2;
          };
          WhoReacted.enabled = true;
          YoutubeAdblock.enabled = true;
        };
      };
    };
  };
}
