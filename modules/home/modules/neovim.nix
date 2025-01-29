{ inputs, pkgs, lib, config, ... }: {
  options.neovim.enable = lib.mkEnableOption "enables Home-Manager NeoVim module";

  # FIXME(aver): does not work on submodules
  config = lib.mkIf config.neovim.enable {
    programs.neovim = {
      enable = true;
      package = pkgs.neovim;
    };

    home.packages = with pkgs; [
      # neovide # remove for the time being, as it gets recompiled with each update
      cppcheck
      bear # add to generate compile_commands.json, if necessary
      marksman
      tree-sitter
      nixd # official nix lsp
      nixfmt-classic
      go
    ];
  };
}
