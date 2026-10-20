{ config, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [

    # Required for Secure Boot
    sbctl
    lon

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
    jetbrains-toolbox
    gcc
    gnumake
    cmake
    go 
    delve
    antigravity-fhs
    lmstudio
    code-cursor-fhs
    python3

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

    # CJK Fonts
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    ipafont

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
    tailscale
    trayscale
    deskflow
    ntfs3g       
    exfatprogs   
    dosfstools

    # Required for Nyrna
    xdotool
    wmctrl

    # Audio stuff
    easyeffects
    pwvucontrol
    qpwgraph

    # Gaming and related stuff
    steam
    steam-run
    wine
    steam-unwrapped
    r2modman
    gamescope
    mangohud
    prismlauncher
    bottles
    winetricks
    protonplus
    heroic
    protontricks
    (import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz") {}).eden
    (discord.override {
      withOpenASAR = true;
      withVencord = true;
    })
  ];

   fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    wqy_zenhei # Fallback for some Asian character render paths
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

  # Required for JetBrains
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
     SDL
     SDL2
     SDL2_image
     SDL2_mixer
     SDL2_ttf
     SDL_image
     SDL_mixer
     SDL_ttf
     alsa-lib
     at-spi2-atk
     at-spi2-core
     atk
     bzip2
     cairo
     cups
     curlWithGnuTls
     dbus
     dbus-glib
     desktop-file-utils
     e2fsprogs
     expat
     flac
     fontconfig
     freeglut
     freetype
     fribidi
     fuse
     fuse3
     gdk-pixbuf
     glew110
     glib
     gmp
     gst_all_1.gst-plugins-base
     gst_all_1.gst-plugins-ugly
     gst_all_1.gstreamer
     gtk2
     harfbuzz
     icu
     keyutils.lib
     libGL
     libGLU
     libappindicator-gtk2
     libcaca
     libcanberra
     libcap
     libclang.lib
     libdbusmenu
     libdrm
     libgcrypt
     libgpg-error
     libidn
     libjack2
     libjpeg
     libmikmod
     libogg
     libpng12
     libpulseaudio
     librsvg
     libsamplerate
     libthai
     libtheora
     libtiff
     libudev0-shim
     libusb1
     libuuid
     libvdpau
     libvorbis
     libvpx
     libxcrypt-legacy
     libxkbcommon
     libxml2
     mesa
     nspr
     nss
     openssl
     p11-kit
     pango
     pixman
     python3
     speex
     stdenv.cc.cc
     tbb
     udev
     vulkan-loader
     wayland
     xorg.libICE
     xorg.libSM
     xorg.libX11
     xorg.libXScrnSaver
     xorg.libXcomposite
     xorg.libXcursor
     xorg.libXdamage
     xorg.libXext
     xorg.libXfixes
     xorg.libXft
     xorg.libXi
     xorg.libXinerama
     xorg.libXmu
     xorg.libXrandr
     xorg.libXrender
     xorg.libXt
     xorg.libXtst
     xorg.libXxf86vm
     xorg.libpciaccess
     xorg.libxcb
     xorg.xcbutil
     xorg.xcbutilimage
     xorg.xcbutilkeysyms
     xorg.xcbutilrenderutil
     xorg.xcbutilwm
     xorg.xkeyboardconfig
     xz
     zlib
  ];

  # Enable KDE Connect
  programs.kdeconnect.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    fontPackages = with pkgs; [ noto-fonts-cjk-sans ];
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
