# Different host profiles when building NixOS

{ inputs, pkgs, nixos-hardware, systemSettings, home-manager, ... }:
let
  lib = inputs.nixpkgs.lib;
  system = systemSettings.system;
in {
  nixos-desktop = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs pkgs systemSettings; };
    modules = [
      home-manager.nixosModules.home-manager
      ./configuration.nix
      ./desktop/hardware-configuration.nix
      ./desktop/configuration.nix
      nixos-hardware.nixosModules.common-cpu-amd-pstate
      nixos-hardware.nixosModules.common-cpu-amd-zenpower
      nixos-hardware.nixosModules.common-cpu-amd
      nixos-hardware.nixosModules.common-gpu-amd
    ];
  };

  nixos-x1c = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs pkgs systemSettings; };
    modules = [
      home-manager.nixosModules.home-manager
      ./configuration.nix
      ./x1c/hardware-configuration.nix
      ./x1c/configuration.nix
      nixos-hardware.nixosModules.lenovo-thinkpad-x1-9th-gen
    ];
  };
}
