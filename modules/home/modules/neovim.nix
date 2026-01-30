{
  pkgs,
  lib,
  config,
  ...
}:
let
  link = config.lib.file.mkOutOfStoreSymlink;
in
{
  options.ave.neovim.enable = lib.mkEnableOption "enables Home-Manager NeoVim module";

  # FIXME(aver): does not work on submodules
  config = lib.mkIf config.ave.neovim.enable {

    # TODO(aver): https://blog.daniel-beskin.com/2025-10-18-symlinking-home-manager
    xdg.configFile = {
      "nvim" = {
        source = link "${config.home.homeDirectory}/dotfiles/nvim/.config/nvim";
        recursive = true;
      };
    };

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

      zsh.shellAliases = {
        vi = "nvim";
        viup = "nvim --headless '+Lazy! sync' +qa";
        vim = "nvim";
      };

      opencode = {
        enable = true;
      };
    };

    home.packages = with pkgs; [
      tree-sitter
      # LSPs and Formatters
      cppcheck
      bear # add to generate compile_commands.json, if necessary
      marksman
      nixd # official nix lsp
      nixfmt
      go
      # rust-analyzer
      # TODO(aver): move these into cli development module
      difftastic
      delta
      onefetch
    ];
  };
}
