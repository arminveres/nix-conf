{ pkgs, lib, config, ... }: {
  options = {
    bluetooth.enable = lib.mkEnableOption "enables Nix bluetooth module";
  };

  config = lib.mkIf config.bluetooth.enable {
    hardware.bluetooth.enable = true; # enables support for Bluetooth
    hardware.bluetooth.powerOnBoot = false; # powers up the default Bluetooth controller on boot
    services.blueman.enable = true;
  };
}
