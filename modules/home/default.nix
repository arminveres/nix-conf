{ inputs, pkgs, lib, systemSettings, ... }: {
  home.username = "${systemSettings.username}";
  home.homeDirectory = "/home/${systemSettings.username}";
  home.stateVersion = "23.11";

  programs = {
    home-manager.enable = true;
    mpv.enable = true;
    zathura = {
      enable = true;
      options = {
        selection-clipboard = "clipboard";
        font = "JetBrainsMono Nerd Font Propo 10";
        scroll-step = 50;
      };
      mappings = {
        "<C-/>" = "recolor";
        "D" = "set first-page-column 1:1";
        # "<C-d>" = "set first-page-column 1:2";
      };
    };
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
    gnome-calculator
    gnome-disk-utility

    dconf
    eza
    fastfetch
    gh
    libreoffice
    kdePackages.okular
    nextcloud-client
    obsidian
    signal-desktop
    spotify
    tldr
    fzf
    ncdu
    imagemagick # for converting stuff
    stow

    # vesktop
    discord

    # TODO(aver): investigate utility
    age
    termshark
    atac
    sshs
    portal
  ];

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };
    mime.enable = true;
  };

  dconf = {
    enable = true;
    settings = { "org/gnome/desktop/interface" = { color-scheme = "prefer-dark"; }; };
  };

  home.pointerCursor = {
    gtk.enable = true;
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;

  };

  gtk = {
    enable = true;
    theme = {
      name = "Colloid-Orange-Dark";
      package = (pkgs.colloid-gtk-theme.override {
        themeVariants = [ "orange" ];
        colorVariants = [ "dark" ];
        tweaks = [ "black" "rimless" "normal" ];
      });
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
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
