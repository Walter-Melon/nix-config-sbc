{ ... }:

{
  wayland.windowManager.hyprland.settings = {
    bind = [
      "CTRL ALT, Delete, exec, hyprctl dispatch exit 0" # exit Hyprland
      "$mainMod, Q, killactive" # close active (not kill)
      "$mainMod SHIFT, Q, exec, $scriptsDir/KillActiveProcess.sh" # Kill active process
      "$mainMod,Return,exec,kitty"
      "$mainMod,B,exec,chromium"
    ];

    bindm = [
      "$mainMod, mouse:272, movewindow"
      "$mainMod, mouse:273, resizewindow"
    ];
  };
}
