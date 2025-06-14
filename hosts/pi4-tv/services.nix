{ ... }: 

{
  services = {
    openssh.enable = true;
    
    xserver = {
      enable = false;
      xkb.layout = "de";
    };
  };
}
