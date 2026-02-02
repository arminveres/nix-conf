{
  lib,
  config,
  systemSettings,
  pkgs,
  ...
}:
let
  link = config.lib.file.mkOutOfStoreSymlink;
in
{
  options.ave.zsh.enable = lib.mkEnableOption "enables Home-Manager ZSH module";

  config = lib.mkIf config.ave.zsh.enable {
    xdg.configFile = {
      "zsh/functions.zsh" = {
        source = link "${config.home.homeDirectory}/nix-conf/dotfiles/zsh/.config/zsh/modules";
        recursive = true;
      };
    };

    programs.zsh = {
      enable = true;
      autocd = true;
      history = {
        append = true;
        expireDuplicatesFirst = true;
        ignoreAllDups = true;
        ignoreSpace = true;
      };
      setOptions = [
        # Treat  the  `#', `~' and `^' characters as part of patterns for filename generation, etc.
        # (An initial unquoted `~' always produces named directory expansion.)
        # "EXTENDED_GLOB"
        "GLOB_DOTS" # match hidden files
        "NOMATCH" # generate an error if a pattern in the arg list is invalid
        "INTERACTIVE_COMMENTS" # allow comments in interactive shell
        "NO_CLOBBER" # do not allow truncating existing files e.g, with >, need to use >| instead
        "APPEND_HISTORY"
        "HIST_VERIFY" # show command with history expansion to user before running it, e.g., !x commands
      ];
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
        # ==================================================================================================
        # Sourcing plugins and custom scripts
        # ==================================================================================================

        # Useful Functions
        source "$ZDOTDIR/modules/functions.zsh"

        # Normal files to source
        # Exports are needed before aliases
        source "$ZDOTDIR/modules/vim_mode.zsh"
        source "$ZDOTDIR/modules/git.zsh"

        # Prompt
        # source "$ZDOTDIR/plugins/git-prompt.zsh/git-prompt.zsh"
        source "$ZDOTDIR/modules/prompt.zsh"

        # Plugins
        # initialize autopair plugin
        autopair-init

        # ==================================================================================================
        # Key-bindings
        # ==================================================================================================
        # bindkey -s '^v' "^U$ZDOTDIR/scripts/fzf_vim.sh^M"
        # bindkey -s '^f' "^Ucdi^M"
        # bindkey -s '^s' "^Utmux-sessionizer^M"
        bindkey -s '^_' "^U$ZDOTDIR/scripts/conf.sh^M"

        bindkey "^[[3~" delete-char
        bindkey '^o' end-of-line
        # bindkey -r "^d"
        # bindkey -r "^u"

        # search using a prefix, e.g., `cd` only searches history including cd
        autoload -U up-line-or-beginning-search && zle -N up-line-or-beginning-search
        autoload -U down-line-or-beginning-search && zle -N down-line-or-beginning-search
        bindkey "^p" up-line-or-beginning-search # Up
        bindkey "^n" down-line-or-beginning-search # Down

        # Edit line in vim with ctrl-e:
        autoload edit-command-line; zle -N edit-command-line
        bindkey '^e' edit-command-line

        # ================================================================================================
        # Distro specifig setup
        # ================================================================================================
        if [[ "$(uname)" == "Linux" ]] && [[ -n "$DISTRO" ]]; then
            case "$DISTRO" in
            Ubuntu | Debian)
                alias nala='sudo nala'
                alias upd='sudo apt update && sudo apt upgrade'
                [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"                   # This loads nvm
                [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion" # This loads nvm bash_completion
                ;;
            Fedora) # echo Fedora
                alias dnf='sudo dnf'
                alias din='dnf install'
                alias dup='dnf upgrade'
                alias doffup='dnf offline-upgrade download -y && dnf offline-upgrade reboot'
                ;;
            *) ;;
            esac
        fi

        if [[ -n $SSH_CONNECTION ]]; then
            # Set window name to hostname when in SSH
            printf '\033k%s\033\\' "$(hostname -s)"
            # Reset window name on exit
            trap 'printf "\033k\033\\"' EXIT
        fi

        # ==================================================================================================
        # END
        # ==================================================================================================
        zsh_end_time=$(python3 -c 'import time; print(int(time.time() * 1000))')
        echo "Shell init time: $((zsh_end_time - zsh_start_time)) ms"
      '';
      plugins = [
        {
          name = "git-prompt";
          src = pkgs.fetchFromGitHub {
            owner = "woefe";
            repo = "git-prompt.zsh";
            rev = "990bdc073bde9b00d9683f19b8d408a5c8a407d6";
            sha256 = "sha256-zlIfEDDcL7DkfXLhLvfzgXZ0Q9Q2jinJ6e+0E+BGR+0=";
          };
        }
        {
          name = "zsh-completions";
          src = pkgs.zsh-completions;
          completions = [ "share/zsh/site-functions" ];
        }
        {
          name = "zsh-autopair";
          src = pkgs.zsh-autopair;
          file = "share/zsh/zsh-autopair/autopair.zsh";
        }
      ];
    };
  };
}
