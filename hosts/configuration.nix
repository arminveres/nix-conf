# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, pkgs, systemSettings, ... }: {

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${systemSettings.username} = (import ../modules/home);
    extraSpecialArgs = { inherit inputs systemSettings; };
  };

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];

      # NOTE(aver): enable nix-community binary caching
      trusted-users = [ systemSettings.username ];
      substituters = [ "https://nix-community.cachix.org" "https://hyprland.cachix.org" ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };

    optimise.automatic = true;
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };
  };

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "${systemSettings.timezone}";

  # Select internationalisation properties.
  i18n.defaultLocale = "${systemSettings.locale}";

  services.displayManager = { autoLogin.enable = false; };

  services.xserver = {
    enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "eu";
    variant = "";
  };

  zramSwap.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    defaultUserShell = pkgs.zsh;
    users.${systemSettings.username} = {
      isNormalUser = true;
      description = "Armin Veres";
      extraGroups = [ "networkmanager" "wheel" "video" "dialout" "plugdev" "gamemode" ];
    };
  };

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.sessionVariables = {
    FLAKE = "/home/${systemSettings.username}/nix-conf?submodules=1";
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
    NAUTILUS_4_EXTENSION_DIR = "${pkgs.nautilus-python}/lib/nautilus/extensions-4";
  };
  environment.pathsToLink = [ "/share/nautilus-python/extensions" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # build utilities
    binutils
    gcc
    cmake
    gnumake
    xxd
    mold
    pkg-config
    qemu

    firefox
    python3
    wget
    alacritty
    git
    stow
    tmux
    nautilus

    nodejs
    zoxide
    ripgrep
    fd
    unzip
    lazygit

    powertop
    wl-clipboard
    pkg-config
    openssl
    baobab

    polkit
    polkit_gnome

    glxinfo
    nh
    lsb-release
    libnotify # enable notify-send
    networkmanagerapplet
    cachix
    libheif
    pavucontrol
    pasystray
    imagemagick
    lshw
    usbutils
    solaar

    hyprland-protocols

    smartmontools # SSD monitoring tools

    # email related packages
    protonmail-bridge
    protonmail-bridge-gui
    thunderbird
  ];

  # TODO(aver): move this into submodule
  xdg.portal = {
    enable = true;
    extraPortals = [
      inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
    configPackages = [ inputs.hyprland.packages.${pkgs.system}.hyprland ];
    xdgOpenUsePortal = true;
  };

  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "alacritty";
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
  };

  programs.zsh.enable = true;

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
  ];

  programs.nix-ld.enable = true;
  programs.light.enable = true;
  programs.direnv.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  programs.ssh.startAgent = true;

  services.zerotierone = {
    enable = true;
    localConf = { settings = { }; };
  };

  security.sudo = {
    enable = true;
    extraRules = [{
      commands = [{
        command = "/run/current-system/sw/bin/nixos-rebuild";
        options = [ "NOPASSWD" ];
      }];
      groups = [ "wheel" ];
    }];
    # wheelNeedsPassword = false;
  };

  services.fwupd.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  networking.firewall.allowedUDPPortRanges = [
    # { from = 6000; to = 9999; } # NOTE(aver): needed for my thesis to make the connections
    {
      from = 51413;
      to = 51413;
    } # qbittorrent
  ];
  networking.firewall.allowedTCPPortRanges = [
    # { from = 5000; to = 9999; } # NOTE(aver): needed for my thesis to make the connections
    {
      from = 51413;
      to = 51413;
    } # qbittorrent
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

  hardware.keyboard.qmk.enable = true;
  hardware.keyboard.zsa.enable = true;

  services.gnome.gnome-keyring.enable = true;

  systemd = {
    user.services = {
      polkit-gnome-authentication-agent-1 = {
        description = "polkit-gnome-authentication-agent-1";
        wantedBy = [ "graphical-session.target" ];
        wants = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    };
    extraConfig = ''
      DefaultTimeoutStopSec=10s
    '';
  };
  security.polkit.enable = true;

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (
        subject.isInGroup("users")
          && (
            action.id == "org.freedesktop.login1.reboot" ||
            action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
            action.id == "org.freedesktop.login1.power-off" ||
            action.id == "org.freedesktop.login1.power-off-multiple-sessions"
          )
        )
      {
        return polkit.Result.YES;
      }
    })
  '';

  services.ratbagd.enable = true;
}
