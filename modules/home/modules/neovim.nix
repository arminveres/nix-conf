{
  pkgs,
  lib,
  config,
  systemSettings,
  ...
}:
let
  helpers = import ../helpers.nix { inherit config systemSettings; };
in
{
  options.ave.neovim.enable = lib.mkEnableOption "enables Home-Manager NeoVim module";

  # FIXME(aver): does not work on submodules
  config = lib.mkIf config.ave.neovim.enable {

    xdg.configFile = (helpers.linkDir "nvim");

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

      zsh = {
        sessionVariables = {
          EDITOR = "${pkgs.neovim}/bin/nvim";
        };
        shellAliases = {
          vi = "nvim";
          viup = "nvim --headless '+Lazy! sync' +qa";
          vim = "nvim";
        };
      };

      opencode = {
        enable = true;
      };
    };

    home.packages = with pkgs; [
      tree-sitter
      # LSPs and Formatters
      lua-language-server
      stylua
      cppcheck
      bear # add to generate compile_commands.json, if necessary
      clang-tools
      marksman
      nixd # official nix lsp
      nixfmt
      taplo
      yaml-language-server
      shfmt
      shellcheck
      prettier
      neocmakelsp
      vscode-json-languageserver
      mdformat
      gitlint
      basedpyright
      bash-language-server
      # docker-language-server
      dockerfile-language-server
      # rust-analyzer
      bitbake-language-server
      systemd-lsp

      # binaries
      go
      jq

      # TODO(aver): move these into cli development module
      difftastic
      delta
      onefetch
      claude-code
      opencode
    ];
  };
}
