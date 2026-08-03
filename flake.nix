{
  description = "Azealo's NixOS Configuration Flake";

  inputs = {
    # Tracks the unstable channel for fresh packages
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    # Zen Browser source
    zen-browser.url = "github:youwen5/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, zen-browser, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
      ];
    };
  };
}