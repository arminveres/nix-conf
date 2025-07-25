{ inputs, pkgs, lib, config, ... }: {
  options = {
    hyprlandwm.enable = lib.mkEnableOption "enables Home-Manager Hyprland module";
    hyprlandwm.hostConfig = lib.mkOption { };
  };

  config = lib.mkIf config.hyprlandwm.enable {

    home.packages = with pkgs; [
      fuzzel
      grim
      gthumb
      hyprcursor
      hyprland-protocols
      hyprland-qt-support
      hyprpicker
      hyprshot
      hyprsysteminfo
      kanshi
      pasystray
      pavucontrol
      playerctl
      pulseaudio
      slurp
      swaynotificationcenter
      swayosd
      udiskie
      waybar
      wdisplays
      wlogout
      wlr-randr
      wofi
      xcur2png
      xdg-utils
    ];

    services = {
      cliphist.enable = true;
      hyprpaper = {
        enable = true;
        settings = {
          preload = [
            "~/nix-conf/dotfiles/wallpapers/Pictures/wallpapers/selected/rim-231014.jpg"
            "~/nix-conf/dotfiles/wallpapers/Pictures/wallpapers/selected/desert-dunes-4k-bx.jpg"
          ];
          # set the default wallpaper(s) seen on initial workspace(s) --depending on the number of monitors used
          wallpaper = [
            "DP-1, ~/nix-conf/dotfiles/wallpapers/Pictures/wallpapers/selected/desert-dunes-4k-bx.jpg"
            "DP-2, ~/nix-conf/dotfiles/wallpapers/Pictures/wallpapers/selected/rim-231014.jpg"
          ];
          #enable splash text rendering over the wallpaper
          splash = false;
        };
      };
      hypridle = {
        enable = true;
        settings = {

          general = {
            lock_cmd = "pidof hyprlock || hyprlock"; # avoid starting multiple hyprlock instances.
            before_sleep_cmd = "loginctl lock-session"; # lock before suspend.
            after_sleep_cmd =
              "hyprctl dispatch dpms on"; # to avoid having to press a key twice to turn on the display.
          };

          listener = [
            {
              timeout = 240;
              on-timeout = "hyprctl dispatch dpms off"; # screen off when timeout has passed
              on-resume =
                "hyprctl dispatch dpms on"; # screen on when activity is detected after timeout has fired.
            }
            {
              timeout = 360;
              on-timeout = "loginctl lock-session"; # lock screen when timeout has passed
            }
            {
              timeout = 900;
              on-timeout =
                "bash -c '[[ -f ~/.config/hypr/sleep_inhibit.flag ]] || systemctl suspend'";
            }
          ];

        };
      };
      hyprpolkitagent.enable = true;
      hyprsunset.enable = false;
    };

    programs.hyprlock = {
      enable = true;
      settings = {
        background = {
          # monitor =
          # path = /home/me/someImage.png   # only png supported for now
          color = "rgba(25, 20, 20, 1.0)";

          # all these options are taken from hyprland, see https://wiki.hyprland.org/Configuring/Variables/#blur for explanations
          blur_passes = 0; # 0 disables blurring
          blur_size = 7;
          noise = 1.17e-2;
          contrast = 0.8916;
          brightness = 0.8172;
          vibrancy = 0.1696;
          vibrancy_darkness = 0.0;
        };

        image = {
          # monitor =
          path = "/home/arminveres/.face";
          size = 150; # lesser side if not 1:1 ratio
          rounding = -1; # negative values mean circle
          border_size = 4;
          border_color = "rgb(221, 221, 221)";
          rotate = 0; # degrees, counter-clockwise

          position = "0, 200";
          halign = "center";
          valign = "center";
        };

        input-field = {
          # monitor =
          size = "200, 50";
          outline_thickness = 3;
          dots_size = 0.33; # Scale of input-field height, 0.2 - 0.8
          dots_spacing = 0.15; # Scale of dots' absolute size, 0.0 - 1.0
          dots_center = false;
          dots_rounding = -1; # -1 default circle, -2 follow input-field rounding
          outer_color = "rgb(151515)";
          inner_color = "rgb(200, 200, 200)";
          font_color = "rgb(10, 10, 10)";
          fade_on_empty = true;
          fade_timeout = 1000; # Milliseconds before fade_on_empty is triggered.
          placeholder_text =
            "<i>Input Password...</i>"; # Text rendered in the input box when it's empty.
          hide_input = false;
          rounding = -1; # -1 means complete rounding (circle/oval)
          check_color = "rgb(204, 136, 34)";
          fail_color =
            "rgb(204, 34, 34)"; # if authentication failed, changes outer_color and fail message color
          fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>"; # can be set to empty
          fail_transition = 300; # transition time in ms between normal outer_color and fail_color
          capslock_color = -1;
          numlock_color = -1;
          bothlock_color =
            -1; # when both locks are active. -1 means don't change outer color (same for above)
          invert_numlock = false; # change color if numlock is off
          swap_font_color = false; # see below

          position = "0, -20";
          halign = "center";
          valign = "center";
        };

        label = {
          # monitor =
          text = "Hello $USER";
          color = "rgba(200, 200, 200, 1.0)";
          font_size = 25;
          font_family = "Iosevka Nerd Font Propo";
          rotate = 0; # degrees, counter-clockwise

          position = "0, 80";
          halign = "center";
          valign = "center";
        };

      };
    };

    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;

      # set the flake package
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage =
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

      systemd.enable = true;
      systemd.variables = [ "--all" ];

      plugins = [ ];

      # https://github.com/nix-community/home-manager/blob/master/tests/modules/services/window-managers/hyprland/simple-config.nix
      settings = lib.recursiveUpdate {
        xwayland = { force_zero_scaling = true; };

        general = {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more
          gaps_in = 5;
          gaps_out = 20;
          border_size = 2;
          layout = "master"; # dwindle
          "col.active_border" = "rgba(83a598ee) rgba(b8bb26ee) 45deg";
          "col.inactive_border" = "rgba(595959aa)";
        };
        input = {
          kb_layout = "eu";
          repeat_rate = 30;
          repeat_delay = 250;

          follow_mouse = 1;
          sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
          touchpad.natural_scroll = true;
        };
        misc = {
          # set adaptive sync rate, 0=off, 1=on, 2=fullscreen only
          vrr = 2;
          vfr = true;
          # we need to set this, otherwise turning dpms off results in off displays
          key_press_enables_dpms = true;
        };
        decoration = {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more
          rounding = 10;
        };

        animations = {
          enabled = true;

          # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
          ];
        };

        binds = {
          # together with previous workspace works like in AwesomeWM
          allow_workspace_cycles = true;
        };
        dwindle = {
          # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
          pseudotile =
            true; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
          preserve_split = true; # you probably want this
        };
        master = {
          # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
          new_status = "master";
          new_on_top = true;
          # orientation = "center";
          # always_center_master = true;
        };
        gestures = {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more
          workspace_swipe = true;
        };

        plugin = {
          # split-monitor-workspaces = { count = 10; };
        };

        # =================================================================================================
        # Keybinds
        # =================================================================================================
        "$mainMod" = "SUPER";

        bind = [
          "$mainMod, return, exec, alacritty"
          "$mainMod SHIFT, c, killactive,"
          # add a windows like launcher
          "$mainMod, b, exec, nautilus" # or thunar
          # "$mainMod, i, exec, firefox"
          "$mainMod, v, togglefloating,"
          "$mainMod, t, pin," # only floating
          "$mainMod, c, centerwindow," # only floating
          "$mainMod, SPACE, exec, fuzzel"
          # "$mainMod, P, pseudo," # dwindle
          # $mainMod, J, togglesplit, # dwindle
          "$mainMod CONTROL, v, exec, ~/.local/bin/rofi-pactl-output"
          "$mainMod, z, exec, ~/.local/bin/rofi-zathura"
          "$mainMod SHIFT, t, togglegroup,"
          "$mainMod, ESCAPE, workspace, previous"
          # Go to urgen workspace and swap back and forth!
          "$mainMod, u, focusurgentorlast"
          # bind = $mainMod, o, focusmonitor, eDP-1 or DP-3
          "$mainMod, f, fullscreen, 0" # use entire screen
          "$mainMod, m, fullscreen, 1" # akin to maximize in AwesomeWM
          # $mainMod, SPACE, togglefloating
          # to switch between windows in a floating workspace
          "$mainMod, Tab, cyclenext," # change focus to another window
          "$mainMod, Tab, bringactivetotop," # bring it to the top

          # Move focus with mainMod + arrow keys
          "$mainMod, h, movefocus, l"
          "$mainMod, l, movefocus, r"
          "$mainMod, k, movefocus, u"
          "$mainMod, j, movefocus, d"

          # Move windows/client in a direction
          "$mainMod SHIFT, h, movewindow, l"
          "$mainMod SHIFT, l, movewindow, r"
          "$mainMod SHIFT, k, movewindow, u"
          "$mainMod SHIFT, j, movewindow, d"

          # resize windows x y
          "ALT CONTROL, l, resizeactive, 40 0"
          "ALT CONTROL, h, resizeactive, -40 0"
          "ALT CONTROL, j, resizeactive, 0 40"
          "ALT CONTROL, k, resizeactive, 0 -40"

          "$mainMod CONTROL, RETURN, layoutmsg, swapwithmaster master"
          "$mainMod CONTROL, h, layoutmsg, addmaster"
          "$mainMod CONTROL, l, layoutmsg, removemaster"
          "$mainMod CONTROL, j, layoutmsg, orientationleft"
          "$mainMod CONTROL, k, layoutmsg, orientationright"
          "$mainMod CONTROL, c, layoutmsg, orientationcenter"

          # Switch workspaces with mainMod + [0-9]
          "$mainMod, q, workspace, 1"
          "$mainMod, w, workspace, 2"
          "$mainMod, e, workspace, 3"
          "$mainMod, r, workspace, 4"
          "$mainMod, t, workspace, 5"
          "$mainMod, y, workspace, 6"
          "$mainMod, u, workspace, 7"
          "$mainMod, i, workspace, 8"
          "$mainMod, o, workspace, 9"
          "$mainMod, p, workspace, 10"

          # Move active window to a workspace with mainMod + SHIFT + [0-9] bind = $mainMod SHIFT, 1, movetoworkspace, 1
          # To bring focus to moved workspace use without 'silent'
          "$mainMod SHIFT, q, movetoworkspacesilent, 1"
          "$mainMod SHIFT, w, movetoworkspacesilent, 2"
          "$mainMod SHIFT, e, movetoworkspacesilent, 3"
          "$mainMod SHIFT, r, movetoworkspacesilent, 4"
          "$mainMod SHIFT, t, movetoworkspacesilent, 5"
          "$mainMod SHIFT, y, movetoworkspacesilent, 6"
          "$mainMod SHIFT, u, movetoworkspacesilent, 7"
          "$mainMod SHIFT, i, movetoworkspacesilent, 8"
          "$mainMod SHIFT, o, movetoworkspacesilent, 9"
          "$mainMod SHIFT, p, movetoworkspacesilent, 10"

          "$mainMod SHIFT, o, movewindow, mon:+1"
          "$mainMod, o, focusmonitor, +1"

          # Scroll through existing workspaces with mainMod + scroll
          "$mainMod, mouse_down, workspace, e+1"
          "$mainMod, mouse_up, workspace, e-1"

          # Sink volume raise optionally with --device
          ", XF86AudioRaiseVolume, exec, swayosd-client --output-volume +5"
          # Sink volume lower optionally with --device
          ", XF86AudioLowerVolume, exec,  swayosd-client --output-volume -5"
          # Sink volume toggle mute
          ", XF86AudioMute, exec, swayosd-client --output-volume mute-toggle"
          # Source volume toggle mute
          ", XF86AudioMicMute, exec, swayosd-client --input-volume mute-toggle"

          # Capslock (If you don't want to use the backend)
          ", --release Caps_Lock, exec, swayosd-client --caps-lock"

          # Brightness raise
          ", XF86MonBrightnessUp, exec, swayosd-client --brightness raise 5"
          # Brightness lower
          ", XF86MonBrightnessDown, exec, swayosd-client --brightness lower 5"

          "$mainMod SHIFT, p, exec, hyprshot --clipboard-only -m window"
          "$mainMod SHIFT, s, exec, hyprshot --clipboard-only -m region"

          "ALT, ESCAPE, exec, wlogout"
        ];

        # allow bindings while locked
        bindl = [
          ", XF86AudioPlay,     exec, playerctl play-pause"
          ", XF86AudioPause,    exec, playerctl pause"
          ", XF86AudioStop,     exec, playerctl stop"
          ", XF86AudioNext,     exec, playerctl next"
          ", XF86AudioPrev,     exec, playerctl previous"
          ", XF86AudioMute,     exec, pactl set-sink-mute @DEFAULT_SINK@ toggle"
          # ", XF86AudioLowerVolume,     exec, pactl set-sink-volume @DEFAULT_SINK@ -5%"
          # ", XF86AudioRaiseVolume,     exec, pactl set-sink-volume @DEFAULT_SINK@ +5%"
        ];

        # Bind to mouse
        bindm = [
          # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
          # Move/resize windows with mainMod + LMB/RMB and dragging
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];

        exec-once = [
          # ''
          #   export "$(${pkgs.gnome-keyring}/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh,gpg)"
          # ''
          # "${pkgs.gnome-keyring}/bin/gnome-keyring-daemon --daemonize --login"
          # "polkit-agent-helper-1"

          "${pkgs.swaynotificationcenter}/bin/swaync"
          "${pkgs.waybar}/bin/waybar"
          "${pkgs.udiskie}/bin/udiskie --tray --notify"
          "${pkgs.pasystray}/bin/pasystray"
          "${pkgs.swayosd}/bin/swayosd-server"
          "${pkgs.kanshi}/bin/kanshi"
          "nm-applet"
          "tmux new -s daemon -d"
          "nextcloud --background"
          "protonmail-bridge-gui --no-window" # "protonmail-bridge -n -l info"
          "corectrl --minimize-systray"
          "solaar -w hide"
        ];
      } config.hyprlandwm.hostConfig;
    };
  };
}
