{ config, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [

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
    gnupg

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
    filezilla
    gearlever
    ffmpeg
    haruna
    vlc
    obs-studio
    thunderbird

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
    protonplus
    heroic
    (discord.override {
      withOpenASAR = true;
      withVencord = true;
    })
  ];

  # Link the Proton-GE nix store path to the user directory.
  # This is needed for using nixpkgs' proton-ge-bin with Heroic and others.
  #
  # Discussion: https://discourse.nixos.org/t/using-proton-ge-bin-package-outside-of-steam/77598/2
  systemd.user.tmpfiles =  {
    enable = true; # Let this fail, if someone changes the default.
    rules = let 
      steaminstalldir = "%h/.local/share/Steam";
      compatdir = "${steaminstalldir}/compatibilitytools.d";
      link = "${compatdir}/Proton-GE";
      target = pkgs.proton-ge-bin.steamcompattool.outPath;
      steamdir = "%h/.steam";
    in [
      "d ${compatdir} - - - - -"
      "L+ ${link} - - - - ${target}"

      # When Steam gets started for the first time, it creates a directory with
      # symlinks to the install directory (among other things). Third party
      # tools are using these to find Proton versions.
      "d ${steamdir} - - - - -"
      "L ${steamdir}/root - - - - ${steaminstalldir}"
      "L ${steamdir}/steam - - - - ${steaminstalldir}"
    ];
  }; 

  # Enable libvirtd daemon
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm; # Reduced download size by only supporting host architecture
      runAsRoot = true;
    };
  };

  # Enable virt-manager GUI
  programs.virt-manager.enable = true;
  

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
    extraCompatPackages = with pkgs; [
    proton-ge-bin
    ];
  };

  # Enable Feral Gamemode
  programs.gamemode.enable = true;

  # Enable AppImage Support
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-curses; # veya pkgs.pinentry-qt / pkgs.pinentry-gnome3
  };

}
