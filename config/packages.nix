{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  services.flatpak.enable = true;
  programs.direnv.enable = true;

  # GENSHIN
  imports = let aagl-gtk-on-nix = import (builtins.fetchTarball "https://github.com/ezKEa/aagl-gtk-on-nix/archive/main.tar.gz"); in [
    aagl-gtk-on-nix.module
  ];
  programs.anime-game-launcher.enable = false;
  programs.honkers-railway-launcher.enable = true;

  # FONTS
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    dina-font
    proggyfonts
  ];

  # SYSTEM PACKAGES
  environment.systemPackages = with pkgs; with gst_all_1; with libsForQt5; [
    # Browsers
    firefox
    vivaldi
    vivaldi-ffmpeg-codecs
    # Communication
    protonmail-bridge
    thunderbird
    # Development Tools
    git
    neovim
    lapce
    lightly-qt
    vscode-fhs
    kate
    kdeconnect-kde
    qt5.qtwebsockets
    qt6.qtwebsockets
    qbittorrent
    unstable.r2modman
    appimage-run
    hugo
    go
    obs-studio
    filezilla
    docker
    protobuf
    nixpkgs-fmt
    # Jetbrains
    jetbrains.webstorm
    jetbrains.rust-rover
    jetbrains.goland
    jetbrains.clion
    jetbrains.idea-ultimate
    # Gaming
    steam
    gamescope
    gamemode
    moonlight-qt
    dwarfs
    prismlauncher
    bottles
    # Graphics
    unstable.aseprite
    # Multimedia
    spotify
    mpv
    # System Utilities
    gnome.gnome-disk-utility
    vesktop
    unstable.webcord-vencord
    fuse-overlayfs
    bubblewrap
    gst-libav
    gst-plugins-bad
    gst-plugins-base
    gst-plugins-good
    gst-plugins-ugly
    gst-vaapi
    kcalc
    droidcam
    libpng
    neofetch
    # CLI replacements
    eza
    bat
    htop
    btop
    fd
    du-dust
    ripgrep
    tokei
    grex
    zoxide
    nushell
  ];

  # STEAM
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  # Package management
  nix = {
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than-7d";
    };
  };

  # Auto updates
  system.autoUpgrade = {
    enable = true;
    channel = "https://nixos.org/channels/nixos-23.11";
  };

  # AppImage integration
  boot.binfmt.registrations.appimage = {
    wrapInterpreterInShell = false;
    interpreter = "${pkgs.appimage-run}/bin/appimage-run";
    recognitionType = "magic";
    offset = 0;
    mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
    magicOrExtension = ''\x7fELF....AI\x02'';
  };
}
