{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.ave = {
    desktop.enable = lib.mkEnableOption "enables Home-Manager Desktop module, which includes basic tools to work with a GUI based system.";
  };

  config = lib.mkIf config.ave.desktop.enable {
    programs = {
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

      # required for my tax software...
      java = {
        enable = true;
        package = pkgs.openjdk17;
      };
    };

    home = {
      packages = with pkgs; [
        gnome-calculator
        gnome-disk-utility
        dconf
        firefox # browser
        alacritty # terminal
        # ghostty  # TODO(aver): 18-07-2025 seems to have some weird loading issues
        nautilus # filebrowser
        baobab # disk usage
        networkmanagerapplet # network tools
        pavucontrol # audio system tray
        solaar # logitech peripherals
        thunderbird # email client
        mission-center
        libreoffice
        kdePackages.okular
        nextcloud-client
        obsidian
        signal-desktop
        # vesktop
        discord
        drawio
      ];

      pointerCursor = {
        gtk.enable = true;
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
        size = 24;
      };

      sessionVariables = {
        GTK_THEME = "Colloid-Orange-Dark";
      };
      file.".face".source = .assets/profile.jpg;
      file.".config/face.jpg".source = .assets/profile.jpg;
    };

    xdg.mime.enable = true;

    dconf = {
      enable = true;
      settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
        };
      };
    };

    gtk = {
      enable = true;
      theme = {
        name = "Colloid-Orange-Dark";
        package = (
          pkgs.colloid-gtk-theme.override {
            themeVariants = [ "orange" ];
            colorVariants = [ "dark" ];
            tweaks = [
              "black"
              "rimless"
              "normal"
            ];
          }
        );
      };
      iconTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
      };
    };
  };
}
