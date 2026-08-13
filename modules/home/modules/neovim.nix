{
  pkgs,
  inputs,
  lib,
  config,
  systemSettings,
  ...
}:
let
  # create a no overlay package variable, because e.g., neovide has issues with rebuilding because of
  # neovim-nightly.
  pkgs-no-overlay = import inputs.nixpkgs {
    inherit (pkgs) system;
    config.allowUnfree = true;
  };
  helpers = import ../helpers.nix { inherit config systemSettings; };
in
{
  options.ave.neovim.enable = lib.mkEnableOption "enables Home-Manager NeoVim module";

  # FIXME(aver): does not work on submodules
  config = lib.mkIf config.ave.neovim.enable {

    xdg.configFile = (helpers.linkDir "nvim");

    programs = {
      # TODO: 20-04-2026 disable program management, as config files may be generated...
      # neovim = { enable = true; package = pkgs.neovim; };

      neovide = {
        enable = true;
        package = pkgs-no-overlay.neovide;
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
        settings = {
          "plugin" = [ "@dietrichgebert/ponytail" ];
        };
        agents = { };
      };

      github-copilot-cli = {
        enable = true;
      };

      claude-code = {
        enable = false;
        skills = { };
      };

    };

    home.packages = with pkgs; [
      inputs.maki.packages.${pkgs.system}.default
      inputs.pi-agent.packages.${pkgs.system}.default
      neovim
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

      # cmake stuff
      neocmakelsp
      cmake-lint
      gersemi

      vscode-json-languageserver
      mdformat
      gitlint
      basedpyright
      bash-language-server
      # docker-language-server
      dockerfile-language-server
      dockerfmt
      # rust-analyzer
      bitbake-language-server
      systemd-lsp
      texlab
      stylelint
      black
      just-lsp
      luajitPackages.luacheck

      # binaries
      go
      jq

      # TODO(aver): move these into cli development module
      difftastic
      delta
      onefetch

      inotify-tools # improved filewatcher for neovim
    ];
  };

}
