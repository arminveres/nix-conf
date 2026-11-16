{
  lib,
  config,
  pkgs,
  systemSettings,
  ...

}:
let
  helpers = import ../helpers.nix { inherit config systemSettings; };
in
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
          "--dir \"$XDG_RUNTIME_DIR\"/keychain"
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

      github-copilot-cli = {
        enable = true;
      };

      claude-code = {
        enable = true;
        skills = { };
      };
    };

    xdg.configFile =
      helpers.linkDir "lazygit"
      // helpers.linkDir "ripgrep"
      // helpers.linkDir "tmux"
      // {
        # global pi-agent instructions: rg/fd instead of grep/find; PI_CODING_AGENT_DIR=$XDG_CONFIG_HOME/pi/agent
        "pi/agent/AGENTS.md".source = helpers.linkSubDir "pi" "agent/AGENTS.md";
        "pi/agent/settings.json".source = helpers.linkSubDir "pi" "agent/settings.json";
      };

    services.tldr-update.enable = true;
    services.proton-pass-agent.enable = false; # TODO: login fail on work laptop/wsl

    home = {
      file = lib.mergeAttrsList (
        map (helpers.linkBin "tmux") [
          "tm"
          "tmp"
          "tms"
        ]
      );

      packages = with pkgs; [
        tldr
        gh # use as package otherwise config is not writable
        lnav
        tmux
      ];

    };
  };
}
