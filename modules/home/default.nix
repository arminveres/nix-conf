{
  pkgs,
  systemSettings,
  overlays,
  inputs,
  ...
}:
{
  # nixpkgs.overlays = overlays;

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
    enable = false; # currently not required, obsidian is synced internally.
    # disable as it does not correctly start as requested
    tray.enable = false;
  };

  home = {
    username = systemSettings.username;
    homeDirectory = systemSettings.homeDirectory;
    # IMPORTANT: set this once and don’t change it casually.
    stateVersion = "26.05"; # pick your HM release/state version
    packages =
      with pkgs;
      [
        nodejs

        # fastfetch
        # gh
        # tldr
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
        inputs.pwndbg.packages.${systemSettings.system}.pwndbg
      ];
  };
}
