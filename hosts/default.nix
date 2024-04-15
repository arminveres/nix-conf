/* 
  Different host profiles when building NixOS
*/

{ inputs
, nixpkgs
, pkgs
, pkgs-stable
, nixos-hardware
, systemSettings
, userSettings
, home-manager
, split-monitor-workspaces
, ...
}:
let
  lib = nixpkgs.lib;
  system = systemSettings.system;
in
{
  desktop = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs pkgs systemSettings userSettings split-monitor-workspaces; };
    modules = [
      home-manager.nixosModules.home-manager
      ./desktop/desktop-hw.nix
      ./configuration.nix
    ];
  };

  x1c = lib.nixosSystem
    {
      inherit system;
      specialArgs = { inherit pkgs inputs; };
      modules = [
        home-manager.nixosModules.home-manager
        ./x1c/x1c-hw.nix
        ./configuration.nix
      ];
    };
}
