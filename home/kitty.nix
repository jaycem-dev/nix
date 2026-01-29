{ pkgs, ... }:
{
  programs.kitty = {
    enable = true;
    enableGitIntegration = true;
    shellIntegration.enableFishIntegration = true;
    font = {
      name = "JetBrains Mono";
      size = 13;
    };
    settings = {
      shell = "${pkgs.fish}/bin/fish";
      cursor_trail = 1;
      # background_opacity = 0.95;
      background_blur = 64;
      tab_bar_edge = "top";
      include = "colors.conf";
    };
  };
}
