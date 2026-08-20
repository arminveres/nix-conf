{ pkgs, systemSettings, ... }:
{
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

  imports = [ ../../modules/core ];

  gaming.enable = true;
  fm.enable = true;
  # bluetooth.enable = true;
  docker.enable = true;
  desktop.enable = true;

  # enable hyprlock pam authentication
  security.pam.services.hyprlock = { };

  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;
    rocmOverrideGfx = "10.3.0";
  };

  home-manager.users.${systemSettings.username} = {
    ave = {
      zsh.enable = true;
      terminal-tools.enable = true;
      neovim.enable = true;
      gaming.enable = true;
      latex.enable = true;
      desktop.enable = true;
      hyprlandwm = {
        enable = true;
        hostConfig = {
          config = {
            cursor = {
              # otherwise my cursor disappears...?
              # no_hardware_cursors = 1;
            };

            input = {
              kb_layout = "eu";
              repeat_rate = 30;
              repeat_delay = 250;

              follow_mouse = 1;
              sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
              touchpad.natural_scroll = true;
            };

            decoration = {
              blur.enabled = true;
              shadow = {
                enabled = true;
                range = 4;
                render_power = 3;
                color = "rgba(1a1a1aee)";
              };
            };
          };

          monitor = [
            # Bitdepth 10 provides some compability issues with screensharing.
            # { output = "DP-1"; mode = "3840x2160@240"; position = "0x0"; scale = 1.5; bitdepth = 10; cm = "hdr"; sdrbrightness = 2.0; sdrsaturation = 0.98; }
            {
              output = "DP-1";
              mode = "3840x2160@240";
              position = "0x0";
              scale = 1.5;
              bitdepth = 10;
            }
            {
              output = "DP-2";
              mode = "1920x1200@60";
              position = "auto-left";
              scale = 1;
            }
          ];

          device = [
            {
              name = "logitech-g-pro--1";
              accel_profile = "flat";
            }
            {
              name = "logitech-usb-receiver";
              accel_profile = "flat";
            }
          ];

          workspace_rule = [
            # code
            {
              workspace = "1";
              monitor = "DP-1";
              default = true;
            }
            # web
            {
              workspace = "2";
              monitor = "DP-1";
            }
            # games
            {
              workspace = "3";
              monitor = "DP-1";
            }
            # research
            {
              workspace = "4";
              monitor = "DP-1";
            }
            {
              workspace = "5";
              monitor = "DP-1";
            }
            # use layout_opts.orientation:top for master placement
            # messages
            {
              workspace = "6";
              monitor = "DP-2";
              default = true;
            }
            # mail
            {
              workspace = "7";
              monitor = "DP-2";
            }
            # sound + bluetooth
            {
              workspace = "8";
              monitor = "DP-2";
            }
            {
              workspace = "9";
              monitor = "DP-2";
            }
            {
              workspace = "10";
              monitor = "DP-2";
            }
          ];

          window_rule = [
            {
              match.class = "^steam$";
              workspace = "3 silent";
            }
            {
              match.class = "^heroic$";
              workspace = "3 silent";
            }
            # add steam games to ws 5
            {
              match.class = "(steam_app_*)";
              workspace = "5 silent";
            }
            {
              match.class = "(steam_app_*)";
              monitor = "0";
            }
            # { match.class = "(steam_app_*)"; fullscreen = true; }

            {
              match.class = "^signal$";
              workspace = "6 silent";
            }
            {
              match.class = "^Signal$";
              workspace = "6 silent";
            }
            {
              match.class = "^discord$";
              workspace = "6 silent";
            }
            {
              match.class = "^Discord$";
              workspace = "6 silent";
            }
            {
              match.class = "^WebCord$";
              workspace = "6 silent";
            }
            {
              match.class = "^vesktop$";
              workspace = "6 silent";
            }
            {
              match.title = "^Microsoft Teams*$";
              workspace = "6 silent";
            }
            {
              match.title = "^Microsoft Teams*$";
              tile = true;
            }

            {
              match.class = "^ch.proton.bridge-gui$";
              workspace = "7 silent";
            }
            {
              match.class = "^thunderbird$";
              workspace = "7 silent";
            }

            {
              match.class = "^Spotify$";
              workspace = "8 silent";
            }
            {
              match.class = "^blueman-manager$";
              workspace = "8 silent";
            }
            {
              match.class = "^easyeffects$";
              workspace = "8 silent";
            }

            {
              match.class = "^org.corectrl.CoreCtrl$";
              workspace = "9 silent";
            }

            {
              match.class = "^org.gnome.Calculator$";
              float = true;
            }
            {
              match.title = "^Friends List$";
              float = true;
            }
          ];

          env = [
            {
              _args = [
                "QT_QPA_PLATFORM"
                "wayland"
              ];
            }
            {
              _args = [
                "GDK_SCALE"
                "1.25"
              ];
            }
            {
              _args = [
                "QT_SCALE"
                "1.25"
              ];
            }
          ];
        };
      };
    };

    services = {
      blueman-applet.enable = false;
      hyprpaper = {
        settings = {
          wallpaper = [
            {
              monitor = "DP-1";
              path = "~/nix-conf/dotfiles/wallpapers/Pictures/wallpapers/selected/desert-dunes-4k-bx.jpg";
            }
            {
              monitor = "DP-2";
              path = "~/nix-conf/dotfiles/wallpapers/Pictures/wallpapers/selected/rim-231014.jpg";
            }
          ];
        };
      };
    };

    programs.keychain.keys = [ "id_ed25519" ];

  };

  hardware = {
    graphics = {
      extraPackages = with pkgs; [
        # amdvlk # NOTE: superseded mainly by radv, https://www.phoronix.com/news/AMDVLK-Four-Months-Go
        # add OpenCL support, or just rely on the amgpu module from `nixos-hardware`
        # rocmPackages.clr.icd
        # clinfo
      ];
      extraPackages32 = with pkgs; [
        # driversi686Linux.amdvlk # NOTE: superseded mainly by radv, https://www.phoronix.com/news/AMDVLK-Four-Months-Go
      ];
      enable32Bit = true;
    };
    probe-rs.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      vulkan-tools
      ddcui
      nvtopPackages.amd
      radeontop

      prusa-slicer
    ];

    # define default driver
    variables.AMD_VULKAN_ICD = "RADV";
  };

  services = {
    #
    # scx_lavd, Steam built gaming first scheduler
    # From NixOS 24.11 onwards, scx is available on Nixpkgs. Using a kernel of version 6.12+ or later is required.
    #
    scx = {
      enable = true;
      scheduler = "scx_lavd"; # default is "scx_rustland"
    };
  };
}
