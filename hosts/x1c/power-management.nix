{ pkgs, ... }:
{
  powerManagement = {
    enable = true;
    # powertop.enable = true; # auto-tune overrides TLP: resets EPP to balance_performance, min_perf_pct to 50
  };
  programs.zsh.shellAliases = {
    ptop = "sudo powertop";
  };
  environment.systemPackages = with pkgs; [ powertop ];

  services = {
    thermald.enable = false; # exits at boot on DYTC ThinkPads: "Thermald can't run on this platform"
    power-profiles-daemon.enable = false;
    tlp = {
      enable = true;
      settings = {
        # https://linrunner.de/tlp/settings/processor.html#cpu-boost-on-ac-bat

        CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
        CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 100;

        CPU_HWP_DYN_BOOST_ON_AC = 1;

        PCIE_ASPM_ON_BAT = "powersupersave";

        #Optional helps save long term battery health
        START_CHARGE_THRESH_BAT0 = 90; # 40 and bellow it starts to charge
        STOP_CHARGE_THRESH_BAT0 = 95; # 80 and above it stops charging
      };
    };
  };
}
