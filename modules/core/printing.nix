{ pkgs, lib, config, ... }: {
  options = {
    printing.enable = lib.mkEnableOption "enables Nix Printing module";
  };

  config = lib.mkIf config.printing.enable {
    environment.systemPackages = with pkgs; [
      cnijfilter2
      canon-cups-ufr2
    ];

    # Enable CUPS to print documents.
    services.printing.enable = true;
    services.printing.drivers = [ pkgs.cnijfilter2 pkgs.canon-cups-ufr2 ];
  };
}
