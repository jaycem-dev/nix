{ lib, compositor, ... }: {
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock"; # avoid starting multiple hyprlock instances.
        before_sleep_cmd = "loginctl lock-session"; # lock before suspend.
        after_sleep_cmd = lib.mkMerge [
          (lib.mkIf (compositor == "hyprland") "hyprctl dispatch dpms on")
          (lib.mkIf (compositor == "niri") "niri msg action power-on-monitors")
        ]; # to avoid having to press a key twice to turn on the display.
      };

      listener = [
        {
          timeout = "150";
          on-timeout = "brightnessctl -s set 10"; # set monitor backlight to minimum, avoid 0 on OLED monitor.
          on-resume = "brightnessctl -r"; # monitor backlight restore.
        }

        # turn off keyboard backlight, comment out this section if you dont have a keyboard backlight.
        {
          timeout = 150;
          on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0";
          on-resume = "brightnessctl -rd rgb:kbd_backlight";
        }

        {
          timeout = 300;
          on-timeout = "loginctl lock-session"; # lock screen when timeout has passed
        }

        (lib.mkIf (compositor == "hyprland") {
          timeout = 330;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "(hyprctl dispatch dpms on) && brightnessctl -r";
        })
        (lib.mkIf (compositor == "niri") {
          timeout = 330;
          on-timeout = "niri msg action power-off-monitors";
          on-resume = "(niri msg action power-on-monitors) && brightnessctl -r";
        })

        {
          timeout = 1800;
          on-timeout = "systemctl suspend"; # suspend pc
        }
      ];
    };
  };
}