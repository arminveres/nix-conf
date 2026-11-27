{
  home-manager,
  inputs,
  overlays,
  pkgs,
  systemSettings,
  ...
}:
let
  # TODO(aver): unify usernames (aver vs arminveres) so a single config suffices.
  #
  # Non-NixOS hosts (e.g. WSL) use a different user than the NixOS hosts.
  mkStandalone =
    username:
    home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
        inherit inputs overlays;
        systemSettings = systemSettings // {
          inherit username;
          homeDirectory = "/home/${username}";
        };
      };
      modules = [
        ../modules/home
        ./ubuntu-cli.nix
      ];
    };
in
{
  # Default standalone user
  ubuntu-cli = mkStandalone "aver";
  # Host-specific user
  SHS0704792C = mkStandalone "arminveres";
}
