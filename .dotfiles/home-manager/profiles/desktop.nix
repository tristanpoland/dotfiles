{
  pkgs,
  self,
  inputs,
  config,
  ...
}: {
  imports = [
    ./common.nix
  ];
  trident = {
    zen-browser.enable = true;
    kitty.enable = false;
    neovim.enable = false;
    vscode.enable = true;
    zed.enable = true;
    bash.enable = true;
    vesktop.enable = true;
    hyfetch.enable = true;
    waybar.enable = false;
    rofi.enable = false;
    gtk.enable = true;
    qt.enable = false;
    xdg.enable = true;
    hyprland = {
      enable = false;
      enablePortal = true;
      defaultBrowser = inputs.zen-browser.packages.${pkgs.system}.default;
      defaultEditor = pkgs.neovim;
      defaultTerminal = pkgs.kitty;

      autostart = with pkgs; [
        waybar
        dunst
      ];
    };
  };
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  home.packages = with pkgs; [
    btop
    wl-clipboard-rs
    github-desktop
#   microsoft-edge
    claude-code
    bitwarden-desktop
    blender
#   warp-terminal
    parsec-bin
    stremio
    zoom-us
    ghostty
    slack
    protonvpn-gui
    vlc
    mpv
    openssl
    protobuf
    rust-analyzer # Used when running
    pkg-config
    alsa-lib
    alsa-utils
    libGL
    vulkan-loader
    vulkan-headers
    vulkan-tools
    wayland
    wayland-protocols
    wayland-scanner
  ];
}
