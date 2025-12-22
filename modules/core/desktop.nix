{ inputs, pkgs, lib, config, systemSettings, ... }: {
  options = {
    desktop.enable = lib.mkEnableOption "enables Nix desktop module. Based on GDM login manager";
  };

  config = lib.mkIf config.desktop.enable {
    # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
    systemd.services."getty@tty1".enable = false;
    systemd.services."autovt@tty1".enable = false;

    services = {
      displayManager = {
        autoLogin.enable = false;
        gdm = {
          enable = true;
          wayland = true;
        };
      };

      # Configure keymap in X11
      xserver.xkb = {
        layout = "eu";
        variant = "";
      };

      # Enable sound with pipewire.
      pulseaudio.enable = false;
      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        # If you want to use JACK applications, uncomment this
        #jack.enable = true;
        # enable for screensharing and whatnot: https://wiki.hyprland.org/Useful-Utilities/Screen-Sharing/
        wireplumber.enable = true;

        # use the example session manager (no others are packaged yet so this is enabled by default,
        # no need to redefine it in your config for now)
        #media-session.enable = true;
      };
      gnome.gnome-keyring.enable = true;
      ratbagd.enable = true;
    };

    environment = {
      pathsToLink = [ "/share/nautilus-python/extensions" ];
      sessionVariables = {
        NAUTILUS_4_EXTENSION_DIR = "${pkgs.nautilus-python}/lib/nautilus/extensions-4";
        # https://wiki.hyprland.org/Getting-Started/Master-Tutorial/#force-apps-to-use-wayland
        NIXOS_OZONE_WL = "1";
        WLR_NO_HARDWARE_CURSORS = "1";
      };
    };

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      configPackages = [ inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland ];
      xdgOpenUsePortal = true;
    };

    programs = {
      nautilus-open-any-terminal = {
        enable = true;
        terminal = "alacritty";
      };
      hyprland = {
        enable = true;
        # xwayland.enable = true;
        # set the flake package
        package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        # make sure to also set the portal package, so that they are in sync
        portalPackage =
          inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      };
      localsend.enable = true;
    };

    fonts.packages = with pkgs; [
      tamzen
      dina-font
      spleen
      envypn-font
      terminus_font
      nerd-fonts.terminess-ttf
      nerd-fonts.meslo-lg
      nerd-fonts.iosevka
      nerd-fonts.iosevka-term
      nerd-fonts.jetbrains-mono
      nerd-fonts.mononoki
    ];
  };
}
