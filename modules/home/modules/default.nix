{
  lib,
  ...
}:
{
  imports = [
    ./gaming.nix
    ./hyprland.nix
    ./neovim.nix
    ./latex.nix
    ./rust.nix
    ./desktop.nix
    ./zsh.nix
  ];
  ave = {
    # First all by default enabled modules
    rustenv.enable = lib.mkDefault true;

    # then all the ones needing manual enabling
    desktop.enable = lib.mkDefault false;
    gaming.enable = lib.mkDefault false;
    hyprlandwm.enable = lib.mkDefault false;
    neovim.enable = lib.mkDefault false;
    latex.enable = lib.mkDefault false;
    zsh.enable = lib.mkDefault false;
  };
}
