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

  # nixpkgs' clang-tools wraps every bin/* with a clangd-oriented wrapper whose shebang is `#!/bin/sh` but whose body uses bash-only syntax ([[ ]], local, (( )) ).
  # On Ubuntu /bin/sh is dash, so clang-format/clang-tidy/etc. fail with "[[: not found".
  # Rewrite the shebang to bash for wrapper scripts only (leaves *-unwrapped ELF binaries and plain scripts like git-clang-format untouched).
  #
  # TODO: remove once fixed upstream
  clang-tools-fixed = pkgs.clang-tools.overrideAttrs (old: {
    postFixup = (old.postFixup or "") + ''
      for f in "$out"/bin/*; do
        [ -f "$f" ] || continue
        if [ "$(head -c 11 "$f")" = "#!/bin/sh" ]; then
          sed -i '1s|^#!/bin/sh|#!/usr/bin/env bash|' "$f"
        fi
      done
    '';
  });
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

    home = {
      file.".config/neocmakelsp/config.toml".source =
        config.lib.file.mkOutOfStoreSymlink "${systemSettings.homeDirectory}/nix-conf/dotfiles/nvim/.config/neocmakelsp/config.toml";

      packages = with pkgs; [
        neovim
        tree-sitter
        # LSPs and Formatters
        lua-language-server
        stylua
        cppcheck
        bear # add to generate compile_commands.json, if necessary
        clang-tools-fixed
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
  };

}
