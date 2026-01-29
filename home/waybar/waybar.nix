{
  lib,
  compositor,
  ...
}:
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = lib.mkMerge [
      {
        mainBar = {
          layer = "top";
          position = "bottom";
          spacing = 10;
          margin = "0 10 5 10";

          "group/system" = {
            orientation = "horizontal";
            modules = [
              "network"
              "bluetooth"
              "battery"
              "pulseaudio"
              "clock"
            ];
          };

          "group/tray-expander" = {
            "orientation" = "inherit";
            "drawer" = {
              transition-duration = 600;
              children-class = "tray-group-item";
              transition-left-to-right = false;
            };
            modules = [
              "custom/expand-icon"
              "tray"
            ];
          };
          "custom/expand-icon" = {
            format = "";
            tooltip = false;
            on-scroll-up = "";
            on-scroll-down = "";
            on-scroll-left = "";
            on-scroll-right = "";
          };

          "hyprland/workspaces" = {
            format = "{icon}";
            format-icons = {
              active = "";
              persistent = "";
              empty = "";
            };
            persistent-workspaces = {
              "*" = 5;
            };
          };

          "hyprland/window" = {
            format = "{title}";
            max-length = 30;
            icon = true;
            icon-size = 16;
          };

          "niri/workspaces" = {
            format = "{icon}";
            format-icons = {
              browser = "";
              dev = "";
              media = "";
              communication = "";
              default = "";
            };
          };

          "niri/window" = {
            format = "{title}";
            max-length = 30;
            icon = true;
            icon-size = 16;
          };

          privacy = {
            icon-spacing = 4;
            icon-size = 18;
            transition-duration = 250;
            modules = [
              {
                type = "screenshare";
                tooltip = true;
                tooltip-icon-size = 24;
              }
              {
                type = "audio-in";
                tooltip = true;
                tooltip-icon-size = 24;
              }
            ];
            ignore-monitor = true;
            ignore = [
              {
                type = "audio-in";
                name = "cava";
              }
            ];
          };

          mpris = {
            format = "{player_icon} {dynamic}";
            format-paused = "{status_icon} {dynamic}";
            dynamic-order = [
              "title"
              "artist"
            ];
            dynamic-len = 40;
            player-icons = {
              default = "";
            };
            status-icons = {
              paused = "";
            };
          };

          "group/actions" = {
            orientation = "inherit";
            modules = [
              "custom/power"
              "idle_inhibitor"
              "group/tray-expander"
            ];
          };
          "custom/power" = {
            format = "";
            tooltip = false;
            on-click = "dmenu-power";
          };

          network = {
            format-wifi = "";
            format-ethernet = "";
            tooltip-format = "Connected to {essid}";
            format-linked = "󱘖 {ifname} (No IP)";
            format-disconnected = " Disconnected";
            interval = 3;
            on-click = "kitty --class 'impala' impala";
          };

          battery = {
            states = {
              warning = 30;
              critical = 15;
            };
            format = "{icon} {capacity}%";
            format-charging = " {capacity}%";
            interval = 1;
            format-icons = [
              ""
              ""
              ""
              ""
              ""
            ];
            tooltip = true;
          };
          pulseaudio = {
            format = "{icon} {volume}%";
            format-muted = " 0%";
            format-icons = {
              headphone = "";
              hands-free = "";
              headset = "";
              phone = "";
              portable = "";
              default = [
                ""
                ""
                ""
              ];
            };
            on-click = "pavucontrol -t 3";
            on-click-right = "pactl --set-sink-mute 0 toggle";
          };
          idle_inhibitor = {
            format = "{icon}";
            format-icons = {
              activated = "";
              deactivated = "";
            };
          };
          clock = {
            interval = 1;
            format = " {:%A %H:%M}";
            on-click = "niri-launch-or-focus-webapp calendar.proton.me";
            tooltip = false;
          };
          tray = {
            icon-size = 16;
            spacing = 5;
          };
          bluetooth = {
            format = "";
            format-off = "";
            format-no-controller = "";
            format-connected = "";
            tooltip-format = "{controller_alias}\n\n{num_connections} connected";
            tooltip-format-connected = "{controller_alias}\n\n{num_connections} connected\n\n{device_enumerate}";
            tooltip-format-enumerate-connected = "{device_alias}";
            tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_battery_percentage}%";
            on-click = "kitty --class 'bluetui' bluetui";
          };
        };
      }
      (lib.mkIf (compositor == "niri") {
        mainBar = {
          modules-left = [
            "group/actions"
            "niri/window"
          ];
          modules-center = [
            "niri/workspaces"
          ];
          modules-right = [
            "mpris"
            "privacy"
            "group/system"
          ];
        };
      })
      (lib.mkIf (compositor == "hyprland") {
        mainBar = {
          modules-left = [
            "tray"
            "hyprland/window"
          ];
          modules-center = [
            "hyprland/workspaces"
          ];
        };
      })
    ];
    style = ''
        @import "colors.css";

        * {
          font-family: "DejaVu Sans", "Font Awesome 6 Free";
          font-size: 12px;
        }

        window#waybar {
          background-color: transparent;
          color: @on_background;
        }

        .module {
            padding: 0 8px;
        }

        tooltip {
            background: @background;
            border: 1px solid @outline_variant;
        }
        tooltip label {
            color: @on_background;
        }

        #bluetooth.off {
            color: @outline_variant;
        }

        #bluetooth.connected {
            color: @secondary;
        }

        #battery.warning {
            color: @error;
        }

        #workspaces, 
        #system, 
        #window,
        #actions, 
        #privacy,
        #mpris {
            background-color: @background;
            border-radius: 10;
            border: 1px solid @outline_variant;
        }

        #privacy {
            color: @tertiary;
        }

      #workspaces button {
          transition: all 0.1s ease;
          padding: 0 10px;
          background: transparent;
          color: @on_background;
          border-radius: 10;
      }

        #workspaces button.empty {
          color: @outline_variant;
        }

        #workspaces button.active {
          color: @on_primary;
          background-color: @primary;
          padding: 0 20px;
        }

        window#waybar.empty #window {
          border: transparent;
          background-color: transparent;
        }

        #tray-expander {
            background-color: @surface_container;
            border-radius: 10;
        }
    '';
  };
}
