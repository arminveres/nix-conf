{
  systemSettings,
  lib,
  config,
  ...
}:
{
  options.ave.zsh.enable = lib.mkEnableOption "enables Home-Manager ZSH module";

  config = lib.mkIf config.ave.zsh.enable {
    programs.zsh = {
      enable = true;
      # autocd = true;
      # history = {
      #   append = true;
      #   expireDuplicatesFirst = true;
      #   ignoreAllDups = true;
      # };
      syntaxHighlighting.enable = true;
      autosuggestion.enable = true;

      sessionVariables = {
        ERRFILE = "$XDG_CACHE_HOME/X11/xsession-errors";
        WINEPREFIX = "$XDG_DATA_HOME/wine";
        RUSTUP_HOME = "$XDG_DATA_HOME/rustup";
        CARGO_HOME = "$XDG_DATA_HOME/cargo";
        PSQL_HISTORY = "$XDG_DATA_HOME/psql_history";
        PGPASSFILE = "$XDG_CONFIG_HOME/pg/pgpass";
        PASSWORD_STORE_DIR = "$XDG_DATA_HOME/pass";
        _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java";
        GRADLE_USER_HOME = "$XDG_DATA_HOME/gradle";
        GNUPGHOME = "$XDG_DATA_HOME/gnupg";
        GTK2_RC_FILES = "$XDG_CONFIG_HOME/gtk-2.0/gtkrc";
        JDTLS_HOME = "$XDG_DATA_HOME/nvim/lsp_servers/jdtls/";
        RIPGREP_CONFIG_PATH = "$XDG_CONFIG_HOME/ripgrep/ripgreprc";
        MANGOHUD_CONFIGFILE = "$XDG_CONFIG_HOME/MangoHud/MangoHud.conf";
        GOPATH = "$XDG_DATA_HOME/go";
        JUPYTER_CONFIG_DIR = "$XDG_CONFIG_HOME/jupyter";
        NETRC_FILE = "$XDG_CONFIG_HOME/netrc";
        MINICOM = "-con";
        NINJA_STATUS = "[%f/%t %p, %oe/s, %es] ";
        DOTNET_ROOT = "$HOME/.dotnet";
        MANPAGER = "nvim +Man!";
        VIMTEX_OUTPUT_DIRECTORY = "build";
        DISTRO = "$(lsb_release -i | awk '{print $3}')";
      };
      envExtra = ''
        path+=(
          /usr/local/bin
          /opt/gcc-arm-none-eabi/bin
          "$HOME"/bin
          "$HOME"/.bin
          "$HOME"/.local/bin
          "$GOPATH"/bin
          "$CARGO_HOME"/bin
          "$XDG_DATA_HOME"/bob/nvim-bin
          "$HOME"/.luarocks/bin
          "$DOTNET_ROOT"
        )
      '';

      completionInit = ''
        # -------------------------------------------------------------------------------------------------
        # Completions Configuration
        # -------------------------------------------------------------------------------------------------

        # We need to set fpath here, because it gets loaded by /etc/zsh* very early
        fpath+=(
          $ZDOTDIR/plugins/zsh-completions/src
          $ZDOTDIR/completion
        )

        # shows current location type
        zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'

        zstyle ':completion:*' menu select
        # insensitive tab completion
        zstyle ':completion:*' matcher-list "" 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
        # groups completion commands
        zstyle ':completion:*' group-name ""
        # squeezes slashes: cd ~//Documents => cd ~/*/Documents
        # zstyle ':completion:*' squeeze-slashes true

        # Add colors from ls to completions
        zstyle ':completion:*:default' list-colors ${"$"}{(s.:.)LS_COLORS}
        zmodload zsh/complist

        _comp_options+=(globdots)      # Include hidden files.

        autoload -Uz compinit && compinit

        # -------------------------------------------------------------------------------------------------
        # END
        # -------------------------------------------------------------------------------------------------
      '';

      shellAliases = {
        hswitch = "home-manager switch -b backup --flake \"${systemSettings.homeDirectory}/nix-conf?submodules=1#ubuntu\" --verbose";
        # ================================================================================================
        # aliasing coreutils
        # ================================================================================================
        # confirm before overwriting something
        cp = "cp -i";
        mv = "mv -i";
        ln = "ln -i";
        mkdir = "mkdir -pv";
        df = "df -h"; # human-readable sizes
        free = "free -m"; # show sizes in MB;
        dd = "dd status=progress";
        mktempdir = "cd $(mktemp -d)";
        visudo = "sudo visudo";
      };
      localVariables = {
        zsh_start_time = "$(python3 -c 'import time; print(int(time.time() * 1000))')";
      };
      # TODO(aver): Integrate into home-manager
      initContent = lib.mkAfter ''
        source $ZDOTDIR/.zshrc.backup
        zsh_end_time=$(python3 -c 'import time; print(int(time.time() * 1000))')
        echo "Shell init time: $((zsh_end_time - zsh_start_time)) ms"
      '';
    };
  };
}
