{ pkgs, lib, config, ... }: {
  options = { power-management.enable = lib.mkEnableOption "enables Nix power-management module"; };

  config = lib.mkIf config.power-management.enable {
    powerManagement.enable = true;
    powerManagement.powertop.enable = true;
    services.thermald.enable = true;
    services.power-profiles-daemon.enable = false;
    services.tlp = {
      enable = true;
      settings = { # https://linrunner.de/tlp/settings/processor.html#cpu-boost-on-ac-bat

        CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
        CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 100;

        CPU_HWP_DYN_BOOST_ON_AC = 1;

        #Optional helps save long term battery health
        START_CHARGE_THRESH_BAT0 = 90; # 40 and bellow it starts to charge
        STOP_CHARGE_THRESH_BAT0 = 95; # 80 and above it stops charging
      };
    };
  };
}
