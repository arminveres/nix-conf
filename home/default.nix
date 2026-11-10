{
  home-manager,
  inputs,
  overlays,
  pkgs,
  systemSettings,
  ...
}:
let
  # Non-NixOS hosts (e.g. WSL) use a different user than the NixOS hosts.
  standaloneSystemSettings = systemSettings // rec {
    username = "aver";
    homeDirectory = "/home/${username}";
  };
in
{
  ubuntu-cli = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    extraSpecialArgs = { inherit inputs overlays; systemSettings = standaloneSystemSettings; };
    modules = [
      ../modules/home
      ./ubuntu-cli.nix
    ];
  };
}
