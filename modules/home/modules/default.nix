{ inputs, nixpkgs, pkgs, lib, ... }: {
  imports = [ ./gaming.nix ./hyprland.nix ./neovim.nix ./latex.nix ./rust.nix ./desktop.nix ];
  # First all by default enabled modules
  rustenv.enable = lib.mkDefault true;
  desktop.enable = lib.mkDefault true;

  # then all the ones needing manual enabling
  gaming.enable = lib.mkDefault false;
  hyprlandwm.enable = lib.mkDefault false;
  neovim.enable = lib.mkDefault false;
  latex.enable = lib.mkDefault false;
}
