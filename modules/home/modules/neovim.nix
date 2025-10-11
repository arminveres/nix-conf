{ pkgs, lib, config, ... }: {
  options.neovim.enable =
    lib.mkEnableOption "enables Home-Manager NeoVim module";

  # FIXME(aver): does not work on submodules
  config = lib.mkIf config.neovim.enable {
    programs = {
      neovim = {
        enable = true;
        package = pkgs.neovim;
      };

      neovide = {
        enable = false;
        settings = {
          font = {
            normal = [ ];
            size = 14.0;
          };
        };
      };
    };

    home.packages = with pkgs; [
      tree-sitter
      # LSPs and Formatters
      cppcheck
      bear # add to generate compile_commands.json, if necessary
      marksman
      nixd # official nix lsp
      nixfmt-classic
      go
      # rust-analyzer
      # TODO(aver): move these into cli development module
      difftastic
      onefetch
    ];
  };
}
