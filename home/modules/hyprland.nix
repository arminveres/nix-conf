{ pkgs, lib, config, inputs, ... }: {
  options = {
    hyprlandwm.enable = lib.mkEnableOption "enables Home-Manager Hyprland module";
    hyprlandwm.displayConfig = lib.mkOption { };
  };

  config = lib.mkIf config.hyprlandwm.enable {

    home.packages = with pkgs; [
      fuzzel
      hyprcursor
      hypridle
      hyprland-protocols
      hyprlock
      hyprpaper
      hyprpicker
      hyprshot
      kanshi
      pavucontrol
      playerctl
      pulseaudio
      swaynotificationcenter
      swayosd
      waybar
      wdisplays
      wlogout
      wofi
      xwaylandvideobridge
      xcur2png
      gthumb

      xdg-utils

      wlr-randr
      grim
      slurp
    ];

    home.file.".config/hypr/hyprlock.conf".source = ../../dotfiles/hypr/.config/hypr/hyprlock.conf;
    home.file.".config/hypr/hypridle.conf".source = ../../dotfiles/hypr/.config/hypr/hypridle.conf;
    home.file.".config/hypr/hyprpaper.conf".source = ../../dotfiles/hypr/.config/hypr/hyprpaper.conf;

    home.sessionVariables.NIXOS_OZONE_WL = "1";
    home.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";


    wayland.windowManager.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      xwayland.enable = true;

      systemd.enable = true;
      systemd.variables = [ "--all" ];

      plugins = [
        # inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
      ];

      # https://github.com/nix-community/home-manager/blob/master/tests/modules/services/window-managers/hyprland/simple-config.nix
      settings = {
        xwayland = {
          force_zero_scaling = true;
        };
        env = [
          "GDK_SCALE,1"
          "QT_SCALE,1"
          "XCURSOR_SIZE,24"
          "HYPRCURSOR_SIZE,24"
          "HYPRCURSOR_THEME,Adwaita"
          "SSH_AUTH_SOCK,$XDG_RUNTIME_DIR/keyring/ssh"
          "QT_QPA_PLATFORM,wayland"
        ];

        general = {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more
          gaps_in = 5;
          gaps_out = 20;
          border_size = 2;
          layout = "master"; #dwindle
          "col.active_border" = "rgba(83a598ee) rgba(b8bb26ee) 45deg";
          "col.inactive_border" = "rgba(595959aa)";
        };
        input = {
          kb_layout = "eu";
          repeat_rate = 30;
          repeat_delay = 250;

          # accel_profile = flat
          follow_mouse = 1;
          sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
          touchpad. natural_scroll = true;
        };
        misc = {
          # set adaptive sync rate, 0=off, 1=on, 2=fullscreen only
          vrr = 1;
          vfr = true;
          # we need to set this, otherwise turning dpms off results in off displays
          key_press_enables_dpms = true;
        };
        decoration = {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more
          rounding = 10;
          drop_shadow = true;
          shadow_range = 4;
          shadow_render_power = 3;
          "col.shadow" = "rgba(1a1a1aee)";
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

        workspace = [
          "1, monitor:DP-1, default:true"
          "2, monitor:DP-1, default:true"
          "3, monitor:DP-1, default:true"
          "4, monitor:DP-1, default:true"
          "5, monitor:DP-1, default:true"
          "10, monitor:DP-2"
        ];

        binds = {
          # together with previous workspace works like in AwesomeWM
          allow_workspace_cycles = true;
        };
        dwindle = {
          # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
          pseudotile = true; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
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

        # only swap keys for the builtin laptop keyboard
        device = {
          name = "at-translated-set-2-keyboard";
          kb_options = "ctrl:swapcaps,altwin:swap_lalt_lwin";
        };
        plugin = {
          split-monitor-workspaces = {
            count = 10;
          };
        };

        # =================================================================================================
        # Keybinds
        # =================================================================================================
        "$mainMod" = "SUPER";

        bind = [
          "$mainMod, return, exec, alacritty"
          "$mainMod SHIFT, c, killactive,"
          "$mainMod, b, exec, thunar"
          "$mainMod, i, exec, firefox"
          "$mainMod, V, togglefloating,"
          "$mainMod, t, pin," # only floating
          "$mainMod, c, centerwindow," # only floating
          "$mainMod, R, exec, fuzzel"
          "$mainMod, P, pseudo," # dwindle
          # $mainMod, J, togglesplit, # dwindle
          "$mainMod CONTROL, o, exec, ~/.local/bin/rofi-pactl-output"
          "$mainMod, z, exec, ~/.local/bin/rofi-zathura"
          "$mainMod SHIFT, t, togglegroup,"
          "$mainMod, ESCAPE, workspace, previous"
          # Go to urgen workspace and swap back and forth!
          "$mainMod, u, focusurgentorlast"
          # bind = $mainMod, o, focusmonitor, eDP-1 or DP-3
          "$mainMod, f, fullscreen, 0" # use entire screen
          "$mainMod, m, fullscreen, 1" # akin to maximize in AwesomeWM
          # $mainMod, SPACE, togglefloating

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
          "$mainMod, 1, workspace, 1"
          "$mainMod, 2, workspace, 2"
          "$mainMod, 3, workspace, 3"
          "$mainMod, 4, workspace, 4"
          "$mainMod, 5, workspace, 5"
          "$mainMod, 6, workspace, 6"
          "$mainMod, 7, workspace, 7"
          "$mainMod, 8, workspace, 8"
          "$mainMod, 9, workspace, 9"
          "$mainMod, 0, workspace, 10"

          # Move active window to a workspace with mainMod + SHIFT + [0-9] bind = $mainMod SHIFT, 1, movetoworkspace, 1
          # To bring focus to moved workspace use without 'silent'
          "$mainMod SHIFT, 1, movetoworkspacesilent, 1"
          "$mainMod SHIFT, 2, movetoworkspacesilent, 2"
          "$mainMod SHIFT, 3, movetoworkspacesilent, 3"
          "$mainMod SHIFT, 4, movetoworkspacesilent, 4"
          "$mainMod SHIFT, 5, movetoworkspacesilent, 5"
          "$mainMod SHIFT, 6, movetoworkspacesilent, 6"
          "$mainMod SHIFT, 7, movetoworkspacesilent, 7"
          "$mainMod SHIFT, 8, movetoworkspacesilent, 8"
          "$mainMod SHIFT, 9, movetoworkspacesilent, 9"
          "$mainMod SHIFT, 0, movetoworkspacesilent, 10"

          # "$mainMod SHIFT, o, split-changemonitor, +1"
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

          "$mainMod SHIFT, p, exec, hyprshot -m window"
          "$mainMod SHIFT, s, exec, hyprshot -m region"

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

        windowrulev2 = [
          "workspace 4 silent,  class:^Spotify$"
          "workspace 4 silent,  class:^blueman-manager$"
          "workspace 4 silent,  class:^easyeffects$"
          "workspace 5 silent,  class:^steam$"
          "workspace 6 silent,  class:^thunderbird$"
          "workspace 9 silent,  class:^signal$"
          "workspace 9 silent,  class:^Signal$"
          "workspace 9 silent,  class:^discord$"
          "workspace 9 silent,  class:^Discord$"
          "workspace 9 silent,  class:^WebCord$"
          "workspace 9 silent,  title:^Microsoft Teams*$"
          "tile,                title:^Microsoft Teams*$"

          # add steam games to ws 6
          "workspace 6 silent,  class:^steam_app_*$"
          # "monitor 0,           class:^steam_app_*$"
          "fullscreen,          class:^steam_app_*$"

          # screen sharing
          "opacity 0.0 override,class:^(xwaylandvideobridge)$"
          "noanim,class:^(xwaylandvideobridge)$"
          "noinitialfocus,class:^(xwaylandvideobridge)$"
          "maxsize 1 1,class:^(xwaylandvideobridge)$"
          "noblur,class:^(xwaylandvideobridge)$"

          "float, class:^org.gnome.Calculator$"
        ];


        exec-once = [
          "export \"$(/run/wrappers/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh,gpg)\""
          "/run/wrappers/bin/gnome-keyring-daemon --daemonize --login"
          "polkit-agent-helper-1"

          "hyprpaper"
          "hypridle"
          "swaync"
          "waybar"
          "udiskie --tray --notify"
          "nm-applet"
          "pasystray"
          "solaar --window hide"
          "tmux new -s daemon -d"
          "swayosd-server"
          "kanshi"
          "cliphist store"
          "nextcloud --backgroud"
          "thunar --daemon"
          "xwaylandvideobridge"

          # "corectrl"

          # TODO(aver): remove this after waybar fixes it itself
          "ln -s $XDG_RUNTIME_DIR/hypr/* /tmp/hypr"
        ];
      } // config.hyprlandwm.displayConfig;
    };
  };
}
