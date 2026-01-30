{
  pkgs,
  systemSettings,
  overlays,
  inputs,
  ...
}:
{
  programs = {
    home-manager.enable = true;
    btop = {
      enable = true;
      settings = {
        vim_keys = true;
        color_theme = "default";
        theme_background = true;
      };
    };
    yazi.enable = true;

    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "${systemSettings.homeDirectory}/nix-conf?submodules=1"; # sets NH_OS_FLAKE variable for you
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
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
      enableZshIntegration = true;
      options = [ "--cmd cd" ];
    };

    direnv = {
      nix-direnv.enable = true;
      enable = true;
      enableZshIntegration = true;
    };

    ripgrep.enable = true;
    fd.enable = true;

  };

  imports = [ ./modules ];

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  services.syncthing = {
    enable = true;
    # disable as it does not correctly start as requested
    tray.enable = false;
  };

  nixpkgs.overlays = overlays;

  home = {
    username = systemSettings.username;
    homeDirectory = systemSettings.homeDirectory;
    # IMPORTANT: set this once and don’t change it casually.
    stateVersion = "26.05"; # pick your HM release/state version
    packages =
      with pkgs;
      [
        nodejs

        # eza
        # fastfetch
        # gh
        # tldr
        # fzf
        # ncdu
        # imagemagick # for converting stuff
        # stow

        # TODO(aver): investigate utility
        # age
        # termshark
        # atac
        # sshs
        # portal
        # miro
      ]
      ++ [
        inputs.pwndbg.packages.${system}.pwndbg
      ];
  };

  programs = {
  };

  # my modules
  ave = {
    neovim.enable = true;
    zsh.enable = true;
  };

}
