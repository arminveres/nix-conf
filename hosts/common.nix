# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  inputs,
  systemSettings,
  pkgs,
  lib,
  ...
}:
# define some libraries used to build stuff in general, e.g., with rust. They are then passed to
# system environment, as well as nix-ld.
let
  myLibs = with pkgs; [
    openssl
    fontconfig.lib
    freetype
  ];
in
{
  # Generate documentation caches, as from NixOS 21.05 they ware not automatically created.
  # https://wiki.nixos.org/wiki/Apropos
  documentation = {
  enable = true;
    man.generateCaches = true;
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
    overlays = [ inputs.neovim-nightly.overlays.default ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${systemSettings.username} = (import ../modules/home);
    extraSpecialArgs = { inherit inputs systemSettings; };
  };

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      # NOTE(aver): enable nix-community binary caching
      trusted-users = [ systemSettings.username ];
      substituters = [
        "https://nix-community.cachix.org"
        "https://hyprland.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };

    optimise.automatic = true;
    # Nix Helper already does cleaning
    # gc = { automatic = true; dates = "daily"; options = "--delete-older-than 7d"; };
  };

  # Set your time zone.
  time.timeZone = "${systemSettings.timezone}";

  # Select internationalisation properties.
  i18n.defaultLocale = "${systemSettings.locale}";

  zramSwap.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    # defaultUserShell = pkgs.zsh;
    users.${systemSettings.username} = {
      isNormalUser = true;
      description = "Armin Veres";
      extraGroups = [
        "networkmanager"
        "wheel"
        "video"
        "dialout"
        "plugdev"
        "gamemode"
      ];
    };
  };

  environment = {
    pathsToLink = [ "/share/nautilus-python/extensions" ];

    sessionVariables = {
      # CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_LINKER = "${pkgs.clang}/bin/clang";
      # CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_RUSTFLAGS =
      #   "-C link-arg=-fuse-ld=${pkgs.mold-wrapped}/bin/mold";

      # When unable to link on gcc/rustc try adding libraries to library path, see difference:
      # https://www.baeldung.com/linux/library_path-vs-ld_library_path
      LIBRARY_PATH = lib.makeLibraryPath myLibs;
      # this worked for openssl-sys dependencies for rust.
      PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig:${pkgs.fontconfig.dev}/lib/pkgconfig:${pkgs.freetype.dev}/lib/pkgconfig";

    };

    # List packages installed in system profile. To search, run: nix search wget
    systemPackages =
      with pkgs;
      [
        # build utilities
        binutils
        gcc
        cmake
        gnumake
        xxd
        qemu

        python3
        wget
        git
        tmux

        nodejs
        unzip

        wl-clipboard

        mesa-demos
        lsb-release
        libnotify # enable notify-send
        cachix
        libheif
        imagemagick
        lshw
        usbutils

        smartmontools # SSD monitoring tools

        cpufetch
        s-tui
        stress-ng
        lm_sensors
      ]
      ++ myLibs;
  };

  programs = {
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/home/${systemSettings.username}/nix-conf?submodules=1"; # sets NH_OS_FLAKE variable for you
    };

    nix-ld = {
      enable = true;
      libraries = myLibs;
    };
    light.enable = true;
    direnv.enable = true;

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # mtr.enable = true;
  };

  services = {

    # Enable the OpenSSH daemon.
    openssh.enable = true;

    zerotierone = {
      enable = true;
      localConf = {
        settings = { };
      };
    };

    fwupd.enable = true;

  };

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
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

  hardware.keyboard.qmk.enable = true;
  hardware.keyboard.zsa.enable = true;

  security.sudo = {
    enable = true;
    extraRules = [
      {
        groups = [ "wheel" ];
        commands = [
          {
            command = "/run/current-system/sw/bin/nixos-rebuild";
            options = [ "NOPASSWD" ];
          }
          {
            command = "/run/current-system/sw/bin/powertop";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];
  };

  security.rtkit.enable = true;
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
}
