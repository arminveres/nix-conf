{ config, lib, pkgs, ... }: {
  boot = {
    # # silence first boot output
    # consoleLogLevel = 3;
    # initrd.verbose = false;
    # initrd.systemd.enable = true;
    # kernelParams = [
    #   "quiet"
    #   "splash"
    #   "intremap=on"
    #   "boot.shell_on_fail"
    #   "udev.log_priority=3"
    #   "rd.systemd.show_status=auto"
    # ];

    # plymouth, showing after LUKS unlock
    plymouth.enable = true;
    plymouth.font =
      "${pkgs.nerd-fonts.mononoki}/share/fonts/truetype/NerdFonts/Mononoki/MononokiNerdFontMono-Regular.ttf";
    plymouth.logo = "${pkgs.nixos-icons}/share/icons/hicolor/128x128/apps/nix-snowflake.png";
  };
}
