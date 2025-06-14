{ ... }: {
  networking = {
    hostName = "pi4-tv";

    networkmanager = {
      enable = true;
      wifi.powersave = false;
    };
  };
}
