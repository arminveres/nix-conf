# Different host profiles when building NixOS

{ inputs, nixos-hardware, systemSettings, home-manager, ... }:
let
  lib = inputs.nixpkgs.lib;
  system = systemSettings.system;
in {
  nixos-desktop = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs systemSettings; };
    modules = [
      home-manager.nixosModules.home-manager
      ./configuration.nix
      ./desktop/hardware-configuration.nix
      ./desktop/configuration.nix
      nixos-hardware.nixosModules.common-cpu-amd-pstate
      # nixos-hardware.nixosModules.common-cpu-amd-zenpower # TODO(aver): 29-03-2025 messes with sensors
      nixos-hardware.nixosModules.common-cpu-amd
      nixos-hardware.nixosModules.common-gpu-amd
      nixos-hardware.nixosModules.common-pc-ssd
      inputs.probe-rs-rules.nixosModules.${systemSettings.system}.default
    ];
  };

  nixos-x1c = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs systemSettings; };
    modules = [
      home-manager.nixosModules.home-manager
      ./configuration.nix
      ./x1c/boot.nix
      ./x1c/hardware-configuration.nix
      ./x1c/configuration.nix
      nixos-hardware.nixosModules.lenovo-thinkpad-x1-9th-gen
      nixos-hardware.nixosModules.common-pc-ssd
    ];
  };
}
