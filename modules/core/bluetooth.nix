{
  lib,
  config,
  systemSettings,
  ...
}:
{
  options = {
    bluetooth.enable = lib.mkEnableOption "enables Nix bluetooth module";
  };

  config = lib.mkIf config.bluetooth.enable {
    hardware = {
      bluetooth = {
        enable = true; # enables support for Bluetooth
        powerOnBoot = false;
      };
    }; # powers up the default Bluetooth controller on boot
    # NOTE: setup rest in HM.

    # setup librepods
    programs.librepods.enable = true;
    users.users.${systemSettings.username}.extraGroups = [ "librepods" ];
  };
}
