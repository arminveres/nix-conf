{ inputs, pkgs, userSettings, lib, ... }: {
  home.username = "${userSettings.username}";
  home.homeDirectory = "/home/${userSettings.username}";
  home.stateVersion = "23.11";

  programs = {
    home-manager.enable = true;
  };

  imports = [ ./modules ];

  home.packages = with pkgs; [
    (colloid-gtk-theme.override {
      themeVariants = [ "orange" ];
      colorVariants = [ "dark" ];
      tweaks = [ "black" "rimless" "normal" ];
    })

    nautilus
    gnome-calculator
    adwaita-icon-theme

    beeper
    dconf
    eza
    fastfetch
    gh
    libreoffice
    mission-center
    nextcloud-client
    obsidian
    rustup
    signal-desktop
    spotify
    tldr
    fzf

    webcord
    vesktop
    discord
    zoom-us
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
      package = pkgs.colloid-gtk-theme;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
  };

  home.sessionVariables = { GTK_THEME = "Colloid-Orange-Dark"; };
  home.file.".face".source = .assets/profile.jpg;

  programs.mpv.enable = true;

  programs.zathura = {
    enable = true;
    options = {
      selection-clipboard = "clipboard";
      font = "Terminus 10";
      scroll-step = 50;
    };
    mappings = {
      "<C-/>" = "recolor";
      "D" = "set first-page-column 1:1";
      # "<C-d>" = "set first-page-column 1:2";
    };
  };

  # NOTE(aver): a better way to automatically stow all my needs files, as in contrast to 
  # sourcing the file, where the files as un-writable
  home.activation = {
    dotfileSetup =
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        pushd /home/${userSettings.username}/nix-conf/dotfiles
        ${pkgs.stow}/bin/stow -vt /home/${userSettings.username} \
             alacritty \
             nvim \
             qmk \
             ripgrep \
             swaync \
             tmux \
             waybar \
             fuzzel \
             zsh \
             xdg
        popd

        pushd /home/${userSettings.username}/nix-conf/dotfiles/dotfiles-secret
        ${pkgs.stow}/bin/stow -vt /home/${userSettings.username} \
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
