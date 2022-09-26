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
    services.printing.drivers = with pkgs; [ brlaser ];
    hardware.printers.ensureDefaultPrinter = "hl-2135w";
    hardware.printers.ensurePrinters = [{
      name = "hl-2135w";
      description = "Brother HL-2135W";
      deviceUri = "lpd://BRW008092B8F915/BINARY_P1";
      location = "Home Office";
      ppdOptions = {
        PageSize = "A4";
        brlaserEconomode = "True";
      };
      model = "drv:///brlaser.drv/br2140.ppd";
    }];
  };
}
