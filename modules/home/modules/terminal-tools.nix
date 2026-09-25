{
  lib,
  config,
  pkgs,
  systemSettings,
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
        # aliases are owned by dotfiles/zsh/.config/zsh/aliases.zsh
        enableZshIntegration = false;
        extraOptions = [
          "--group"
          "--group-directories-first"
        ];
      };

      fzf = {
        enable = true;
        enableZshIntegration = lib.mkIf config.ave.zsh.enable true;
        tmux.enableShellIntegration = true;
        # defaultCommand = "rg --hidden -l ''";
        # defaultCommand = "fd --type f";
        defaultOptions = [
          "--cycle"
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
            overrideGpg = true;
            autoStageResolvedConflicts = false;
            diffRenderers = [
              { command = "delta --paging=never --side-by-side"; }
              {
                command = "difft --color=always --syntax-highlight=off";
                type = "extDiff";
              }
              # { command = "delta --paging=never"; } TODO: lg does not support delta with inline comparison
            ];
            branchPrefix = ''{{ runCommand "bash -c '[[ \"$(git remote -v)\" =~ \"varian\" ]] && printf \"u/ave/\" || true'" }}'';
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
          theme = "Visual Studio Dark+";
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
          lad = "${pkgs.lazydocker}/bin/lazydocker";
        };
      };

      uv.enable = true;

      pi-coding-agent = {
        enable = true;
        context = "";
        extraPackages = with pkgs; [
          nodejs
          bun
          pnpm
        ];
      };
    };

    services.tldr-update.enable = true;

    home = {
      # global pi-agent instructions: rg/fd instead of grep/find
      file = {
        ".pi/agent/AGENTS.md".source =
          config.lib.file.mkOutOfStoreSymlink "${systemSettings.homeDirectory}/nix-conf/dotfiles/pi/.pi/agent/AGENTS.md";
        ".pi/agent/settings.json".source =
          config.lib.file.mkOutOfStoreSymlink "${systemSettings.homeDirectory}/nix-conf/dotfiles/pi/.pi/agent/settings.json";
      };

      packages = with pkgs; [
        tldr
        gh # use as package otherwise config is not writable
      tmux
      ];

    };
  };
}
