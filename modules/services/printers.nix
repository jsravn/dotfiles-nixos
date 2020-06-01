{ config, options, pkgs, lib, ... }:
with lib; {
  options.modules.services.printers = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.services.printers.enable {
    services.printing.enable = true;
    services.printing.drivers = with pkgs; [ unstable.brlaser ];
    hardware.printers.ensureDefaultPrinter = "hl-2135w";
    hardware.printers.ensurePrinters = [{
      name = "hl-2135w";
      description = "Brother HL-2135W";
      deviceUri = "ipp://192.168.82.5";
      location = "Home Office";
      ppdOptions = { PageSize = "A4"; };
      model = "drv:///brlaser.drv/br2140.ppd";
    }];
  };
}
