{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.ave.hyprlandwm = {
    enable = lib.mkEnableOption "enables Home-Manager Hyprland module";
    hostConfig = lib.mkOption { };
  };

  config = lib.mkIf config.ave.hyprlandwm.enable {

    home = {
      packages = with pkgs; [
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
        udiskie
        waybar
        wdisplays
        wlogout
        wlr-randr
        xcur2png
        xdg-utils
      ];

      pointerCursor = {
        enable = true;
        hyprcursor = {
          enable = true;
          size = 32;
        };
      };
    };

    services = {

      gnome-keyring.enable = true;

      cliphist.enable = true;
      hyprpaper = {
        enable = true;
        settings = {
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
            after_sleep_cmd = "hyprctl dispatch dpms on"; # to avoid having to press a key twice to turn on the display.
          };

          listener = [
            {
              timeout = 480;
              on-timeout = "hyprctl dispatch dpms off"; # screen off when timeout has passed
              on-resume = "hyprctl dispatch dpms on"; # screen on when activity is detected after timeout has fired.
            }
            {
              timeout = 600;
              on-timeout = "loginctl lock-session"; # lock screen when timeout has passed
            }
            {
              timeout = 900;
              on-timeout = "bash -c '[[ -f ~/.config/hypr/sleep_inhibit.flag ]] || systemctl suspend'";
            }
          ];

        };
      };

      hyprpolkitagent.enable = true;

      hyprsunset = {
        enable = true;
        settings = {
          max-gamma = 150;
          profile = [
            {
              time = "7:30";
              identity = true;
            }
            {
              time = "21:00";
              temperature = 5000;
              gamma = 0.8;
            }
          ];
        };
      };

      swayosd = {
        enable = true;
      };

      swaync = {
        enable = true;
      };
    };

    programs = {

      hyprlock = {
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
            placeholder_text = "<i>Input Password...</i>"; # Text rendered in the input box when it's empty.
            hide_input = false;
            rounding = -1; # -1 means complete rounding (circle/oval)
            check_color = "rgb(204, 136, 34)";
            fail_color = "rgb(204, 34, 34)"; # if authentication failed, changes outer_color and fail message color
            fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>"; # can be set to empty
            # TODO(aver): does not exist
            # fail_transition = 300; # transition time in ms between normal outer_color and fail_color
            capslock_color = -1;
            numlock_color = -1;
            bothlock_color = -1; # when both locks are active. -1 means don't change outer color (same for above)
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

      fuzzel = {
        enable = true;
        settings = {
          main = {
            font = "Mononoki Nerd Font Propo:weight=bold";
            terminal = "${pkgs.alacritty}/bin/alacritty -e";
            dpi-aware = "yes";
            layer = "overlay";

            lines = 10;
            width = 80;
            tabs = 8;
            horizontal-pad = 30;
            vertical-pad = 20;
            inner-pad = 10;
            image-size-ratio = 0.5;
            line-height = 30;
          };
          colors = {
            background = "1d2021f0";
            text = "fbf1c7ff";
            match = "fb4934ff";
            selection = "fe8019dd";
            selection-text = "ffffffff";
            selection-match = "000000ff";
            border = "98971a00";
          };
          border = {
            width = 1;
            radius = 20;
          };
        };
      };

      zsh.initContent = ''
        function resprg() {
          pkill $1
          hyprctl dispatch exec $1
        }
      '';
    };

    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;

      # do not set the packages, use those from top NixOS module:
      # https://wiki.hypr.land/Nix/Hyprland-on-Home-Manager/#using-the-home-manager-module-with-nixos
      package = null;
      portalPackage = null;

      # Since Hyprland 0.55 the config is written in Lua instead of hyprlang.
      # https://wiki.hypr.land/Configuring/Start/
      configType = "lua";

      systemd.enable = false;
      systemd.variables = [ "--all" ];

      plugins = [ ];

      # All hyprlang categories (general/input/misc/decoration/...) are
      # merged under a single `config` key, which home-manager renders as one
      # `hl.config({...})` call. Host-specific overrides (monitor, device,
      # env, window/workspace rules, config.input, config.decoration, ...)
      # are merged in via hostConfig.
      # https://github.com/nix-community/home-manager/blob/master/tests/modules/services/window-managers/hyprland/lua-config.nix
      settings = lib.recursiveUpdate {
        config = {
          xwayland = {
            force_zero_scaling = true;
          };

          general = {
            # See https://wiki.hypr.land/Configuring/Basics/Variables/ for more
            gaps_in = 2;
            gaps_out = 5;
            border_size = 2;
            layout = "master"; # dwindle
            col = {
              active_border = {
                colors = [
                  "rgba(83a598ee)"
                  "rgba(b8bb26ee)"
                ];
                angle = 45;
              };
              inactive_border = "rgba(595959aa)";
            };
          };

          input = {
            kb_layout = "eu";
            repeat_rate = 30;
            repeat_delay = 250;

            follow_mouse = 0;
            sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
            touchpad.natural_scroll = true;
          };

          misc = {
            # set adaptive sync rate, 0=off, 1=on, 2=fullscreen only
            vrr = 2;
            # vfr = true;
            # we need to set this, otherwise turning dpms off results in off displays
            key_press_enables_dpms = true;
            # allow to restore if the monitor goes off; happens with my OLED when regenerating
            allow_session_lock_restore = true;
          };

          decoration = {
            # See https://wiki.hypr.land/Configuring/Basics/Variables/ for more
            rounding = 5;
          };

          animations = {
            enabled = false;
          };

          binds = {
            # together with previous workspace works like in AwesomeWM
            allow_workspace_cycles = true;
          };

          dwindle = {
            # See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/
            preserve_split = true; # you probably want this
          };

          master = {
            # See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/
            new_status = "master";
            new_on_top = true;
          };
        };
      } config.ave.hyprlandwm.hostConfig;

      # =================================================================================================
      # Keybinds & autostart
      # https://wiki.hypr.land/Configuring/Basics/Binds/
      # https://wiki.hypr.land/Configuring/Basics/Dispatchers/
      # =================================================================================================
      extraConfig = ''
        local mainMod = "SUPER"

        hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd("alacritty"))
        hl.bind(mainMod .. " + SHIFT + C", hl.dsp.window.close())
        -- add a windows like launcher
        hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("nautilus")) -- or thunar
        hl.bind(mainMod .. " + V", hl.dsp.window.float())
        hl.bind(mainMod .. " + T", hl.dsp.window.pin()) -- only floating
        hl.bind(mainMod .. " + C", hl.dsp.window.center()) -- only floating
        hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("fuzzel"))
        hl.bind(mainMod .. " + CTRL + V", hl.dsp.exec_cmd("~/.local/bin/rofi-pactl-output"))
        hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd("~/.local/bin/rofi-zathura"))
        hl.bind(mainMod .. " + CTRL + T", hl.dsp.group.toggle())
        hl.bind(mainMod .. " + ESCAPE", hl.dsp.focus({ workspace = "previous" }))
        -- Go to urgent workspace and swap back and forth!
        hl.bind(mainMod .. " + CTRL + U", hl.dsp.focus({ urgent_or_last = true }))
        hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen" })) -- use entire screen
        hl.bind(mainMod .. " + M", hl.dsp.window.fullscreen({ mode = "maximized" })) -- akin to maximize in AwesomeWM

        -- to switch between windows in a floating workspace
        hl.bind(mainMod .. " + Tab", function()
          hl.dispatch(hl.dsp.window.cycle_next())   -- change focus to another window
          hl.dispatch(hl.dsp.window.bring_to_top()) -- bring it to the top
        end)

        -- Move focus with mainMod + arrow keys
        hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "l" }))
        hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "r" }))
        hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "u" }))
        hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "d" }))

        -- Move windows/client in a direction
        hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "l" }))
        hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "r" }))
        hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "u" }))
        hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "d" }))

        -- resize windows x y
        hl.bind("ALT + CTRL + L", hl.dsp.window.resize({ x = 40, y = 0, relative = true }))
        hl.bind("ALT + CTRL + H", hl.dsp.window.resize({ x = -40, y = 0, relative = true }))
        hl.bind("ALT + CTRL + J", hl.dsp.window.resize({ x = 0, y = 40, relative = true }))
        hl.bind("ALT + CTRL + K", hl.dsp.window.resize({ x = 0, y = -40, relative = true }))

        hl.bind(mainMod .. " + CTRL + RETURN", hl.dsp.layout("swapwithmaster master"))
        hl.bind(mainMod .. " + CTRL + H", hl.dsp.layout("orientationleft"))
        hl.bind(mainMod .. " + CTRL + J", hl.dsp.layout("orientationbottom"))
        hl.bind(mainMod .. " + CTRL + K", hl.dsp.layout("orientationtop"))
        hl.bind(mainMod .. " + CTRL + L", hl.dsp.layout("orientationright"))
        hl.bind(mainMod .. " + CTRL + C", hl.dsp.layout("orientationcenter"))

        -- Switch workspaces with mainMod + [q w e r t y u i o p]
        local workspaceKeys = { "q", "w", "e", "r", "t", "y", "u", "i", "o", "p" }
        for i, key in ipairs(workspaceKeys) do
          hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
          -- Move active window to a workspace with mainMod + SHIFT + key, without following
          hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i, follow = false }))
        end

        -- Scroll through existing workspaces with mainMod + scroll
        hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
        hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

        -- Sink volume raise optionally with --device
        hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("swayosd-client --output-volume +5"))
        -- Sink volume lower optionally with --device
        hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("swayosd-client --output-volume -5"))
        -- Sink volume toggle mute
        hl.bind("XF86AudioMute", hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"))
        -- Source volume toggle mute
        hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("swayosd-client --input-volume mute-toggle"))

        -- Capslock (if you don't want to use the backend)
        hl.bind("Caps_Lock", hl.dsp.exec_cmd("swayosd-client --caps-lock"), { release = true })

        -- Brightness lower
        hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("swayosd-client --brightness lower"))
        -- Brightness raise
        hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("swayosd-client --brightness raise"))

        hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd("hyprshot --clipboard-only -m window"))
        hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("hyprshot --clipboard-only -m region"))
        hl.bind(mainMod .. " + SHIFT + X", hl.dsp.exec_cmd("hyprshot --output-folder ~/Pictures/screenshots -m region"))

        hl.bind("ALT + ESCAPE", hl.dsp.exec_cmd("wlogout"))

        -- allow bindings while locked
        hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
        hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl pause"), { locked = true })
        hl.bind("XF86AudioStop", hl.dsp.exec_cmd("playerctl stop"), { locked = true })
        hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
        hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
        hl.bind("XF86AudioMute", hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ toggle"), { locked = true })

        -- Move/resize windows with mainMod + LMB/RMB and dragging
        hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
        hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

        -- Autostart, runs once on Hyprland startup (not on every config reload).
        hl.on("hyprland.start", function()
          hl.exec_cmd("${pkgs.swaynotificationcenter}/bin/swaync")
          hl.exec_cmd("${pkgs.waybar}/bin/waybar")
          hl.exec_cmd("${pkgs.udiskie}/bin/udiskie --tray --notify")
          hl.exec_cmd("${pkgs.pasystray}/bin/pasystray")
          hl.exec_cmd("${pkgs.kanshi}/bin/kanshi")
          hl.exec_cmd("nm-applet")
          hl.exec_cmd("corectrl --minimize-systray")
          hl.exec_cmd("solaar -w hide")
          hl.exec_cmd("xrdb ~/.Xresources")
        end)
      '';
    };

  };
}
