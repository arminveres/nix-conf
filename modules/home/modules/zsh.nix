{
  lib,
  config,
  systemSettings,
  pkgs,
  ...
}:
let
  helpers = import ../helpers.nix { inherit config systemSettings; };
in
{
  options.ave.zsh.enable = lib.mkEnableOption "enables Home-Manager ZSH module";

  config = lib.mkIf config.ave.zsh.enable {

    xdg.configFile = {
      "zsh/modules".source = helpers.linkSubDir "zsh" "modules";
      "zsh/completion".source = helpers.linkSubDir "zsh" "completion";
    };

    # set the shell here, nowhere else.
    home.sessionVariables = {
      SHELL = "${pkgs.zsh}/bin/zsh";
    };

    programs.zsh = {
      enable = true;
      # enable for profiling
      zprof.enable = false;
      autocd = true;
      history = {
        append = true;
        expireDuplicatesFirst = true;
        ignoreAllDups = true;
        ignoreSpace = true;
      };
      setOptions = [
        "AUTO_PUSHD" # Make cd push the old directory onto the directory stack.
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

        # Location where Zsh dumps its completion cache (speeds up startup)
        ZSH_COMPLETION_DUMP = "$XDG_CACHE_HOME/zsh/.zcompdump";
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

        _comp_options+=(globdots)      # Include hidden files.

        # We need to set fpath here, because it gets loaded by /etc/zsh* very early
        fpath+=(
          "$ZDOTDIR/plugins/zsh-completions/src"
          "$ZDOTDIR/completion"
        )

        autoload -Uz compinit

        # Glob Logic:
        # #q : Start glob qualifiers
        # N  : Nullglob (don't error if file missing)
        # .  : Plain files only
        # mh : Modification time in hours
        # +24: Older than 24 hours
        if [[ ! -f "$ZSH_COMPLETION_DUMP" || -n "$ZSH_COMPLETION_DUMP"(#qN.mh+24) ]]; then

            # Scenario A: Cache is old or missing. Rebuild.
            # -i: Ignore insecure directories (don't ask user)
            # -u: Use insecure directories (silently)
            # -d: Dump path
            compinit -i -u -d "$ZSH_COMPLETION_DUMP"

            # Touch the file to reset its modification time, preventing compaudit loops
            touch "$ZSH_COMPLETION_DUMP"
        else

            # Scenario B: Cache is fresh. Fast Load.
            # -C: Skip ALL security checks, trust the dump file
            compinit -C -d "$ZSH_COMPLETION_DUMP"

        fi


        # Compile for speed
        if [[ ! -f "$ZSH_COMPLETION_DUMP.zwc" || "$ZSH_COMPLETION_DUMP" -nt "$ZSH_COMPLETION_DUMP.zwc" ]]; then
            zcompile "$ZSH_COMPLETION_DUMP" &!

        fi

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

        # -------------------------------------------------------------------------------------------------
        # END
        # -------------------------------------------------------------------------------------------------
      '';

      shellAliases = {
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
        nxfclean = "nh clean all --keep 3 --optimise";
        nxclean = "nh clean user --keep 3 --optimise";
      };

      localVariables = {
        zsh_start_time = "$(python3 -c 'import time; print(int(time.time() * 1000))')";
        ZMODULES = "$ZDOTDIR/modules";
      };

      initContent = ''
        # ==================================================================================================
        # Sourcing plugins and custom scripts
        # ==================================================================================================
        source "$ZMODULES/dotdot.zsh"
        source "$ZMODULES/functions.zsh"

        # Normal files to source
        # Exports are needed before aliases
        source "$ZMODULES/vim_mode.zsh"
        source "$ZMODULES/git.zsh"

        # Prompt
        source "$ZMODULES/prompt.zsh"

        # initialize autopair plugin
        autopair-init

        # ==================================================================================================
        # Key-bindings
        # ==================================================================================================
        # TODO(aver): use zmodload to get proper escapes, see
        # https://github.com/adityastomar67/zsh-conf/blob/b20cf56556d68cb743edb07e872a8cbf121d4a61/zsh/conf.d/keybinds.zsh#L36
        source "$ZMODULES/keybinds.zsh"
        # bindkey -s '^s' "^Utmux-sessionizer^M"

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
            NixOS)
                # Pretty print log messages
                function log() {
                    printf "\n<<<< $1 >>>>\n\n"
                }

                #
                # Rebuilds the system on my remote server
                #
                function rrebuild() {
                    nixos-rebuild switch \
                        --flake "$FLAKE#$(hostname)" \
                        --build-host arminserver-zt \
                        --use-remote-sudo
                }

                # Create a flake out of a directory/repository
                function flakify() {
                    if [ ! -e flake.nix ]; then
                        nix flake new -t github:nix-community/nix-direnv .
                    elif [ ! -e .envrc ]; then
                        echo "use flake" >.envrc
                        direnv allow
                    fi
                    ${"EDITOR:-vim"} flake.nix
                }

                # Update flake based nix setup and create a commit with the date and time
                function nxup() {
                    local GIT_REPO=$HOME/nix-conf

                    log "Running NixOS system update"
                    if ! nh os boot --update; then
                        log "Update failed!"
                        return
                    fi

                    log "Creating commit for update"
                    pushd $GIT_REPO
                    git commit $GIT_REPO/flake.lock \
                        -m "build(flake): update lockfile $(date -u +%Y-%m-%dT%H:%M%Z)"
                    if [[ $? -ne 0 ]]; then
                        git commit --amend \
                            -m "build(flake): update lockfile $(date -u +%Y-%m-%dT%H:%M%Z)"
                    fi
                    popd
                    log "Update successful!"
                }
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


        ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[red]%}"
        ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[green]%}●"
        ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$fg[red]%}"
        ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}"

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
