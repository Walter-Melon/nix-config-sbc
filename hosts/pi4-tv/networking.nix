{...}:

let
  hostname = "pi4-tv";
  interface = "wlan0";
in {
  networking = {
    hostName = "pi4-tv";
    # wireless = {
    #   enable = true;
    #   networks."${SSID}".psk = SSIDpassword;
    #   interfaces = [ interface ];
    # };
  };
}