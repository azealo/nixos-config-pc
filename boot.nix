{ config, pkgs, lib, ... }:

let
  sources = import ./lon.nix;
  lanzaboote = import sources.lanzaboote {
    inherit pkgs;
  };
in
{
  imports = [ lanzaboote.nixosModules.lanzaboote ];

  environment.systemPackages = [
    # For debugging and troubleshooting Secure Boot
    pkgs.sbctl
  ];

  boot = {
    # Bootloader
    # Lanzaboote takes over systemd-boot management
    loader.systemd-boot.enable = lib.mkForce false;
    loader.efi.canTouchEfiVariables = true;

    # Lanzaboote Secure Boot configuration
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };

    # Linux Kernel
    kernelPackages = pkgs.linuxPackages_latest;

    # Enable Plymouth Boot Animation
    plymouth = {
      enable = true;
      theme = "bgrt";
      # themePackages = with pkgs; [
      #   # By default we would install all themes
      #   (adi1090x-plymouth-themes.override {
      #     selected_themes = [ "rings" ];
      #   })
      # ];
    };

    # Low swappiness keeps swap idle until system RAM is genuinely full
    kernel.sysctl = {
      "vm.swappiness" = 10;
    };  

    # Enable "Silent boot"
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
      "clearcpuid=umip"
    ];

    # Hide the OS choice for bootloaders.
    # It's still possible to open the bootloader list by pressing any key
    # It will just not appear on screen unless a key is pressed 
    loader.timeout = 0;
  };

  # Emergency swap
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024; # Size in MB
    }
  ];
}