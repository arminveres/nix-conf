{ inputs
, config
, pkgs
, pkgs-stable
, systemSettings
, userSettings
, split-monitor-workspaces
, ...
}:

{
  programs = {
    home-manager.enable = true;
  };

  home.packages = with pkgs; [
    dconf
    colloid-gtk-theme
    colloid-icon-theme
    gnome.adwaita-icon-theme
    signal-desktop
    beeper
    discord
    neovide
    kanshi
    wlogout
    pulseaudio
    pavucontrol
    wdisplays
    mission-center
    gh
    eza
    rustup
    tldr
    nextcloud-client
    gamemode
  ];

  home.username = userSettings.username;
  home.homeDirectory = "/home/" + userSettings.username;
  home.stateVersion = "23.11";

  xdg.enable = true;
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };
  xdg.mime.enable = true;
  xdg.mimeApps.enable = true;
  xdg.configFile = {
    "gtk-4.0/assets".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
    "gtk-4.0/gtk.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
    "gtk-4.0/gtk-dark.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
  };

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
      name = "Colloid-Dark";
      package = pkgs.colloid-gtk-theme;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.gnome.adwaita-icon-theme;
    };
    cursorTheme = {
      name = "Adwaita";
      package = pkgs.gnome.adwaita-icon-theme;
    };
  };
  home.sessionVariables = { GTK_THEME = "Colloid-Dark"; };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    plugins = [
      # split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
    ];
    extraConfig = ''
      # See https://wiki.hyprland.org/Configuring/Monitors/
      monitor=DP-1,3440x1440@1440,0x0,1.0
      monitor=DP-2,1920x1200@60,3440x0,1.0,transform,3

      workspace=DP-0,1
      workspace=DP-1,11

      env = XCURSOR_SIZE,24

      # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
      input {
          kb_layout = eu
          repeat_rate = 30
          repeat_delay = 250

          # accel_profile = flat
          follow_mouse = 1
          sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
          touchpad {
              natural_scroll = true
          }
      }

      general {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more
          gaps_in = 5
          gaps_out = 20
          border_size = 2
          # #83a598ee #b8bb26ee
          col.active_border = rgba(83a598ee) rgba(b8bb26ee) 45deg
          col.inactive_border = rgba(595959aa)

          layout = master #dwindle
      }

      misc {
          # set adaptive sync rate, 0=off, 1=on, 2=fullscreen only
          vrr = 1
          # we need to set this, otherwise turning dpms off results in off displays
          key_press_enables_dpms = true
      }

      decoration {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more
          rounding = 10
          drop_shadow = true
          shadow_range = 4
          shadow_render_power = 3
          col.shadow = rgba(1a1a1aee)
      }

      animations {
          enabled = true

          # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

          bezier = myBezier, 0.05, 0.9, 0.1, 1.05

          animation = windows, 1, 7, myBezier
          animation = windowsOut, 1, 7, default, popin 80%
          animation = border, 1, 10, default
          animation = borderangle, 1, 8, default
          animation = fade, 1, 7, default
          animation = workspaces, 1, 6, default
      }

      binds {
          # together with previous workspace works like in AwesomeWM
          allow_workspace_cycles = true
      }

      dwindle {
          # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
          pseudotile = true # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
          preserve_split = true # you probably want this
      }

      master {
          # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
          new_is_master = true
          new_on_top = true
      }

      gestures {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more
          workspace_swipe = true
      }

      # Example per-device config
      # See https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs for more

      # only swap keys for the builtin laptop keyboard
      device {
          name = at-translated-set-2-keyboard 
          kb_options = ctrl:swapcaps,altwin:swap_lalt_lwin
      }

      plugin {
          split-monitor-workspaces {
              count = 9
          }
      }

      # =================================================================================================
      # Keybinds
      # =================================================================================================

      # See https://wiki.hyprland.org/Configuring/Keywords/ for more
      $mainMod = SUPER

      # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
      bind = $mainMod, return, exec, alacritty
      bind = $mainMod SHIFT, c, killactive,
      bind = $mainMod, b, exec, thunar
      bind = $mainMod, i, exec, firefox
      bind = $mainMod, V, togglefloating,
      bind = $mainMod, t, pin, # only floating
      bind = $mainMod, c, centerwindow, # only floating
      bind = $mainMod, R, exec, wofi --show drun --allow-images
      bind = $mainMod, P, pseudo, # dwindle
      # bind = $mainMod, J, togglesplit, # dwindle
      bind = $mainMod CONTROL, o, exec, ~/.local/bin/rofi-pactl-output
      bind = $mainMod, z, exec, ~/.local/bin/rofi-zathura

      bind = $mainMod SHIFT, t, togglegroup,

      bind = $mainMod, ESCAPE, workspace, previous
      # Go to urgen workspace and swap back and forth!
      bind = $mainMod, u, focusurgentorlast
      # bind = $mainMod, o, focusmonitor, eDP-1 or DP-3
      bind = $mainMod, f, fullscreen, 0 # use entire screen
      bind = $mainMod, m, fullscreen, 1 # akin to maximize in AwesomeWM
      # bind = $mainMod, SPACE, togglefloating

      # Move focus with mainMod + arrow keys
      bind = $mainMod, h, movefocus, l
      bind = $mainMod, l, movefocus, r
      bind = $mainMod, k, movefocus, u
      bind = $mainMod, j, movefocus, d

      # Move windows/client in a direction
      bind = $mainMod SHIFT, h, movewindow, l
      bind = $mainMod SHIFT, l, movewindow, r
      bind = $mainMod SHIFT, k, movewindow, u
      bind = $mainMod SHIFT, j, movewindow, d

      # resize windows x y
      bind = ALT CONTROL, l, resizeactive, 40 0
      bind = ALT CONTROL, h, resizeactive, -40 0
      bind = ALT CONTROL, j, resizeactive, 0 40
      bind = ALT CONTROL, k, resizeactive, 0 -40

      bind = $mainMod CONTROL, RETURN, layoutmsg, swapwithmaster master
      bind = $mainMod CONTROL, h, layoutmsg, addmaster
      bind = $mainMod CONTROL, l, layoutmsg, removemaster
      bind = $mainMod CONTROL, j, layoutmsg, orientationleft
      bind = $mainMod CONTROL, k, layoutmsg, orientationright

      # Switch workspaces with mainMod + [0-9]
      bind = $mainMod, 1, workspace, 1
      bind = $mainMod, 2, workspace, 2
      bind = $mainMod, 3, workspace, 3
      bind = $mainMod, 4, workspace, 4
      bind = $mainMod, 5, workspace, 5
      bind = $mainMod, 6, workspace, 6
      bind = $mainMod, 7, workspace, 7
      bind = $mainMod, 8, workspace, 8
      bind = $mainMod, 9, workspace, 9
      bind = $mainMod, 0, workspace, 10

      # Move active window to a workspace with mainMod + SHIFT + [0-9] bind = $mainMod SHIFT, 1, movetoworkspace, 1
      # To bring focus to moved workspace use without 'silent'
      bind = $mainMod SHIFT, 1, movetoworkspacesilent, 1
      bind = $mainMod SHIFT, 2, movetoworkspacesilent, 2
      bind = $mainMod SHIFT, 3, movetoworkspacesilent, 3
      bind = $mainMod SHIFT, 4, movetoworkspacesilent, 4
      bind = $mainMod SHIFT, 5, movetoworkspacesilent, 5
      bind = $mainMod SHIFT, 6, movetoworkspacesilent, 6
      bind = $mainMod SHIFT, 7, movetoworkspacesilent, 7
      bind = $mainMod SHIFT, 8, movetoworkspacesilent, 8
      bind = $mainMod SHIFT, 9, movetoworkspacesilent, 9
      bind = $mainMod SHIFT, 0, movetoworkspacesilent, 10

      bind = $mainMod SHIFT, o, swapactiveworkspaces, eDP-1 DP-3

      # Scroll through existing workspaces with mainMod + scroll
      bind = $mainMod, mouse_down, workspace, e+1
      bind = $mainMod, mouse_up, workspace, e-1

      # Move/resize windows with mainMod + LMB/RMB and dragging
      bindm = $mainMod, mouse:272, movewindow
      bindm = $mainMod, mouse:273, resizewindow

      # Sink volume raise optionally with --device
      bind = , XF86AudioRaiseVolume, exec, swayosd-client --output-volume raise
      # Sink volume lower optionally with --device
      bind = , XF86AudioLowerVolume, exec,  swayosd-client --output-volume lower
      # Sink volume toggle mute
      bind = , XF86AudioMute, exec, swayosd-client --output-volume mute-toggle
      # Source volume toggle mute
      bind = , XF86AudioMicMute, exec, swayosd-client --input-volume mute-toggle

      # Volume raise with custom value
      bind = , XF86AudioRaiseVolume, exec, swayosd-client --output-volume 5
      # Volume lower with custom value
      bind = , XF86AudioLowerVolume, exec, swayosd-client --output-volume -5

      # Capslock (If you don't want to use the backend)
      bind = , --release Caps_Lock, exec, swayosd-client --caps-lock
      # Capslock but specific LED name (/sys/class/leds/)
      bind = , --release Caps_Lock, exec, swayosd-client --caps-lock-led input19::capslock

      # Brightness raise
      bind = , XF86MonBrightnessUp, exec, swayosd-client --brightness raise 5
      # Brightness lower
      bind = , XF86MonBrightnessDown, exec, swayosd-client --brightness lower 5

      bind = $mainMod SHIFT, p, exec, hyprshot -m window
      bind = $mainMod SHIFT, s, exec, hyprshot -m region

      # allow bindings while locked
      bindl =, XF86AudioPlay,     exec, playerctl play-pause
      bindl =, XF86AudioPause,    exec, playerctl pause
      bindl =, XF86AudioStop,     exec, playerctl stop
      bindl =, XF86AudioNext,     exec, playerctl next
      bindl =, XF86AudioPrev,     exec, playerctl previous
      bindl =, XF86AudioMute,     exec, pactl set-sink-mute @DEFAULT_SINK@ toggle
      bindl =, XF86AudioLowerVolume,     exec, pactl set-sink-volume @DEFAULT_SINK@ -5%
      bindl =, XF86AudioRaiseVolume,     exec, pactl set-sink-volume @DEFAULT_SINK@ +5%

      bind = ALT, ESCAPE, exec, wlogout

      # =================================================================================================
      # Rules
      # =================================================================================================
      # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more

      windowrulev2=workspace 4 silent,class:^(Spotify)$
      windowrulev2=workspace 4 silent,class:^(blueman-manager)$
      windowrulev2=workspace 4 silent,class:^(easyeffects)$
      windowrulev2=workspace 6 silent,class:^(steam)$
      windowrulev2=workspace 9 silent,class:^(signal)$
      windowrulev2=workspace 9 silent,class:^(Signal)$
      # teams
      windowrulev2=workspace 9 silent,title:^(Microsoft Teams*)$
      windowrulev2=tile,title:^(Microsoft Teams*)$

      # =================================================================================================
      # Autostart Application
      # =================================================================================================

      env = SSH_AUTH_SOCK,$XDG_RUNTIME_DIR/ssh-agent.socket
      env = QT_QPA_PLATFORM,wayland
      exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
      exec-once = systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
      exec-once = hyprpaper
      exec-once = export "$(/run/wrappers/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh,gpg)"
      exec-once = /run/wrappers/bin/gnome-keyring-daemon --daemonize --login
      exec-once = swaync
      exec-once = waybar

      # exec-once = lxpolkit
      # exec-once = swayidle -w

      exec-once = udiskie --tray --notify
      exec-once = nm-applet
      exec-once = pasystray
      exec-once = solaar --window hide
      exec-once = tmux new -s daemon -d

      exec-once = systemctl --user enable ssh-agent.service && systemctl --user start ssh-agent.service
      exec-once = swayosd-server
      exec-once = kanshi
      exec-once = cliphist store
    '';
  };
}
