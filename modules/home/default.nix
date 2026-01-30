{ inputs, pkgs, lib, systemSettings, ... }: {
  home.username = "${systemSettings.username}";
  home.homeDirectory = "/home/${systemSettings.username}";
  home.stateVersion = "23.11";

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

    java = {
      enable = true;
      package = pkgs.openjdk17;
    };

  };

  imports = [ ./modules ];

  home.packages = with pkgs; [
    eza
    fastfetch
    gh
    tldr
    fzf
    ncdu
    imagemagick # for converting stuff
    stow

    # TODO(aver): investigate utility
    age
    termshark
    atac
    sshs
    portal
    miro
  ];

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
}
