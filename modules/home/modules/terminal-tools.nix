{
  pkgs,
  lib,
  config,
  ...
}:
let
  link = config.lib.file.mkOutOfStoreSymlink;
in
{
  options.ave.terminal-tools.enable = lib.mkEnableOption "enables Home-Manager Terminal Tools module";

  config = lib.mkIf config.ave.terminal-tools.enable {
    programs.eza = {
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

    lazygit = {
      enable = true;
      enableZshIntegration = lib.mkIf config.ave.zsh.enable true;
      # TODO(aver): Consider moving configuration here.
    };

  };
}
