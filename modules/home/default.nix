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
    mime.enable = true;
  };

  home.sessionVariables = { GTK_THEME = "Colloid-Orange-Dark"; };
  home.file.".face".source = .assets/profile.jpg;
  home.file.".config/face.jpg".source = .assets/profile.jpg;

  # NOTE(aver): a better way to automatically stow all my needs files, as in contrast to 
  # sourcing the file, where the files as un-writable
  home.activation = {
    dotfileSetup = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      pushd /home/${systemSettings.username}/nix-conf/dotfiles
      ${pkgs.stow}/bin/stow -vt /home/${systemSettings.username} \
           alacritty \
           ghostty \
           nvim \
           scripts \
           qmk \
           ripgrep \
           swaync \
           tmux \
           waybar \
           fuzzel \
           zsh \
           wlogout \
           xdg
      popd

      pushd /home/${systemSettings.username}/nix-conf/dotfiles/dotfiles-secret
      ${pkgs.stow}/bin/stow -vt /home/${systemSettings.username} \
          git \
          ssh
      popd
    '';
  };

  services.syncthing = {
    enable = true;
    # disable as it does not correctly start as requested
    tray.enable = false;
  };
}
