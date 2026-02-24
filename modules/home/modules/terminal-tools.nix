{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.ave.terminal-tools.enable = lib.mkEnableOption "enables Home-Manager Terminal Tools module";

  config = lib.mkIf config.ave.terminal-tools.enable {
    programs = {
      eza = {
        enable = true;
        colors = "always";
        icons = "always";
        git = true; # do i need this?
        enableZshIntegration = lib.mkIf config.ave.zsh.enable true;
      };

      fzf = {
        enable = true;
        enableZshIntegration = lib.mkIf config.ave.zsh.enable true;
        tmux.enableShellIntegration = true;
        # defaultCommand = "rg --hidden -l ''";
        # defaultCommand = "fd --type f";
        defaultOptions = [
          "--height 40%"
          "--layout=reverse"
          "--border"
        ];
      };

      zoxide = {
        enable = true;
        enableZshIntegration = lib.mkIf config.ave.zsh.enable true;
        options = [ "--cmd cd" ];
      };

      direnv = {
        nix-direnv.enable = true;
        enable = true;
        enableZshIntegration = lib.mkIf config.ave.zsh.enable true;
      };

      ripgrep.enable = true;
      fd.enable = true;

      lazydocker.enable = true;

      lazygit = {
        enable = true;
        enableZshIntegration = false;
        settings = {
          git = {
            autoStageResolvedConflicts = false;
            pagers = [
              { pager = "delta --paging=never --side-by-side"; }
              { externalDiffCommand = "difft --color=always --syntax-highlight=off"; } # --display=inline
              { pager = "delta --paging=never"; }
            ];
          };
          os = {
            copyToClipboardCmd = ''
              if [[ "$TERM" =~ ^(screen|tmux) ]]; then
                printf "\033Ptmux;\033\033]52;c;$(printf {{text}} | base64 -w 0)\a\033\\" > /dev/tty
              else
                printf "\033]52;c;$(printf {{text}} | base64 -w 0)\a" > /dev/tty
              fi
            '';
          };
        };
      };

      bat = {
        enable = true;
        config = {
          pager = "less --RAW-CONTROL-CHARS --quit-if-one-screen --mouse";
          theme = "TwoDark";
          style = "plain";
        };
      };

      keychain = {
        enable = true;
        enableZshIntegration = lib.mkIf config.ave.zsh.enable true;
        extraFlags = [
          "--noask"
          "--quiet"
          "--quick"
        ];
      };

      # Extra shell configs for these tools
      zsh = {
        initContent = ''
          #
          # Use a better lg function alias
          #
          function lg {
            pushd $(realpath .) >/dev/null
            lazygit
            popd >/dev/null
          }
        '';
        shellAliases = {
          lad = "lazydocker";
        };
      };

    };

    services.tldr-update.enable = true;
    home.packages = with pkgs; [ tldr ];
  };
}
