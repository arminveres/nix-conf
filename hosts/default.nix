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
    specialArgs = { inherit inputs pkgs systemSettings userSettings; };
    modules = [
      home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.${userSettings.username} = (import ../home);
          extraSpecialArgs = { inherit inputs pkgs-stable systemSettings userSettings split-monitor-workspaces; };
        };
      }
      ./desktop-hw.nix
      ./configuration.nix
    ];
  };
  x1c = lib.nixosSystem
    {
      inherit system;
      specialArgs = { inherit pkgs inputs; };
      modules = [
        # home-manager.nixosModules.home-manager
        ./x1c-hw.nix
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${userSettings.username} = (import ../home);
          extraSpecialArgs = { inherit inputs pkgs-stable systemSettings userSettings split-monitor-workspaces; };
        }
      ];
    };
}
