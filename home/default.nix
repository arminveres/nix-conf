{
  home-manager,
  inputs,
  overlays,
  pkgs,
  systemSettings,
  ...
}:
{
  ubuntu-cli = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    extraSpecialArgs = { inherit inputs systemSettings overlays; };
    modules = [
      ../modules/home
      ./ubuntu-cli.nix
    ];
  };
}
