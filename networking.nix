{ config, pkgs, ... }:

{
  # Enable networking
  networking.networkmanager.enable = true;

  programs.throne = {
   enable = true;
   tunMode.enable = true;
  };

  # Firewall Settings
  networking.firewall = {
    enable = true;
    checkReversePath = "loose";

    # Open ports for Soulseek/Nicotine+
    allowedTCPPorts = [
      2234
      2235
      59100
      24800
    ];
    allowedUDPPorts = [
      2234
      2235
      59100
      59200
    ];
  };
}
