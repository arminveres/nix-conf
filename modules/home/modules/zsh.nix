{
  lib,
  config,
  systemSettings,
  pkgs,
  ...
}:
let
  helpers = import ../helpers.nix { inherit config systemSettings; };

  # Files under dotfiles/zsh/.config/zsh that are symlinked into $ZDOTDIR.
  # Everything zsh related lives there, this module only wires it up.
  linkedEntries = [
    "modules"
    "completion"
    "plugins"
    "env.zsh"
    "options.zsh"
    "completion.zsh"
    "plugins.zsh"
    "aliases.zsh"
    "distro.zsh"
    "profile.zsh"
    "rc.zsh"
    "logout.zsh"
  ];
in
{
  options.ave.zsh.enable = lib.mkEnableOption "enables Home-Manager ZSH module";

  config = lib.mkIf config.ave.zsh.enable {

    xdg.configFile = lib.listToAttrs (
      map (entry: lib.nameValuePair "zsh/${entry}" { source = helpers.linkSubDir "zsh" entry; }) linkedEntries
    );

    # set the shell here, nowhere else.
    home.sessionVariables = {
      SHELL = "${pkgs.zsh}/bin/zsh";
    };

    programs.zsh = {
      enable = true;
      # enable for profiling
      zprof.enable = false;

      # All actual configuration lives in dotfiles/zsh, keeping it usable
      # without nix. Home-Manager only generates the entry points that source it.
      envExtra = ''
        source "$ZDOTDIR/env.zsh"
      '';

      profileExtra = ''
        source "$ZDOTDIR/profile.zsh"
      '';

      completionInit = ''
        source "$ZDOTDIR/completion.zsh"
      '';

      initContent = ''
        source "$ZDOTDIR/rc.zsh"
      '';

      logoutExtra = ''
        source "$ZDOTDIR/logout.zsh"
      '';
    };
  };
}
