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
        autoUpdate = false;
        autoUpdateNotification = false;
        enableReactDevtools = false;
        enabledThemes = [];
        notifyAboutUpdates = false;
        plugins = {
          BetterFolders = { enabled = false; };
          BetterGifPicker = { enabled = true; };
          BetterUploadButton = { enabled = true; };
          BiggerStreamPreview = { enabled = true; };
          CallTimer = { enabled = true; format = "human"; };
          Decor = { enabled = true; };
          Experiments = { enabled = true; toolbarDevMenu = false; };
          FakeNitro = {
            disableEmbedPermissionCheck = false;
            emojiSize = 48;
            enableEmojiBypass = true;
            enableStickerBypass = true;
            enableStreamQualityBypass = true;
            enabled = false;
            hyperLinkText = "{{NAME}}";
            stickerSize = 160;
            transformCompoundSentence = false;
            transformEmojis = true;
            transformStickers = true;
            useHyperLinks = true;
          };
          FavGifSearch = { enabled = true; searchOption = "hostandpath"; };
          FixCodeblockGap = { enabled = true; };
          FixImagesQuality = { enabled = true; };
          FixYoutubeEmbeds = { enabled = true; };
          FriendInvites = { enabled = true; };
          FriendsSince = { enabled = true; };
          GreetStickerPicker = { enabled = true; greetMode = "Greet"; };
          LoadingQuotes = {
            additionalQuotes = "Actually finish this one day you dummy!";
            additionalQuotesDelimiter = "|";
            enableDiscordPresetQuotes = false;
            enablePluginPresetQuotes = false;
            enabled = true;
            replaceEvents = true;
          };
          MessageClickActions = {
            enableDeleteOnClick = true;
            enableDoubleClickToEdit = true;
            enableDoubleClickToReply = true;
            enabled = true;
            requireModifier = false;
          };
          NewGuildSettings = {
            enabled = true;
            events = true;
            everyone = true;
            guild = true;
            hightlights = true;
            messages = 1;
            role = true;
            showAllChannels = true;
          };
          NoReplyMention = {
            enabled = true;
            inverseShiftReply = false;
            shouldPingListed = true;
            userList = "";
          };
          PlatformIndicators = {
            badges = true;
            colorMobileIndicator = true;
            enabled = true;
            list = true;
            messages = true;
          };
          RoleColorEverywhere = {
            chatMention = true;
            colorChatMessages = false;
            enabled = true;
            memberList = true;
            messageSaturation = 30;
            pollResults = true;
            reactorsList = true;
            voiceUsers = true;
          };
          SecretRingToneEnabler = { enabled = false; onlySnow = false; };
          ShikiCodeblocks = { bgOpacity = 100; enabled = true; tryHljs = "SECONDARY"; useDevIcon = "COLOR"; };
          ShowAllMessageButtons = { enabled = true; };
          SpotifyShareCommands = { enabled = true; };
          ValidReply = { enabled = true; };
          ValidUser = { enabled = true; };
          VolumeBooster = { enabled = true; multiplier = 2; };
          WhoReacted = { enabled = true; };
          YoutubeAdblock = { enabled = true; };
          petpet = { enabled = true; };
        };
        themeLinks = cfg.themeLinks;
        useQuickCss = true;
        winNativeTitleBar = true;
        frameless = false;
        transparent = true;
      };
    };
  };
}
