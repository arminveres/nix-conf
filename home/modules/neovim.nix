{ pkgs, lib, config, ... }:
{
  options = {
    neovim.enable = lib.mkEnableOption "enables Home-Manager NeoVim module";
  };

  # FIXME(aver): does not work on submodules
  config = lib.mkIf config.neovim.enable {
    home.packages = with pkgs;[
      cppcheck
      marksman
      tree-sitter
    ];
  };
}
