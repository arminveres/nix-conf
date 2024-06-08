{ inputs, nixpkgs, pkgs, lib, config, ... }:
{
  options = {
    neovim.enable = lib.mkEnableOption "enables Home-Manager NeoVim module";
  };

  # FIXME(aver): does not work on submodules
  config = lib.mkIf config.neovim.enable {
    programs.neovim = {
      enable = true;
      package = pkgs.neovim;
    };

    home.packages = with pkgs;[
      # neovide
      cppcheck
      marksman
      tree-sitter
    ];
  };
}
