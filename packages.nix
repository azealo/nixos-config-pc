{ config, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [

    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    
    # KDE Packages
    kdePackages.kdenlive
    kdePackages.filelight
    kdePackages.partitionmanager
    kdePackages.kate

    # Development stuff
    curl
    wget
    git
    jdk
    vscodium-fhs
    opencode
    nixfmt

    # For Shell and Terminal
    micro
    fastfetch
    jetbrains-mono
    nerd-fonts.jetbrains-mono
    meslo-lgs-nf
    alacritty
    btop
    fzf
    zsh-powerlevel10k
    zsh-history-substring-search
    distrobox
    distroshelf
    podman

    # General programs
    qbittorrent
    proton-vpn
    lollypop
    unrar
    nicotine-plus
    obsidian
    gimp
    wl-clipboard
    tauon
    libreoffice
    chromium
    handbrake
    audacity
    gparted
    logmein-hamachi
    haguichi

    # Required for Nyrna
    xdotool
    wmctrl

    # Audio stuff
    easyeffects
    pwvucontrol
    qpwgraph

    # Gaming and related stuff
    wine
    steam
    steam-run
    steam-unwrapped
    r2modman
    gamescope
    mangohud
    prismlauncher
    bottles
    winetricks
    (discord.override {
      withOpenASAR = true;
      withVencord = true;
    })
  ];

  # Install firefox.
  programs.firefox.enable = true;

  programs.nix-ld.enable = true;

  # Enable KDE Connect
  programs.kdeconnect.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    extraCompatPackages = [
      # Install ProtonGE
      pkgs.proton-ge-bin
    ];
  };

  # Enable Feral Gamemode
  programs.gamemode.enable = true;

  # Enable AppImage Support
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

}
