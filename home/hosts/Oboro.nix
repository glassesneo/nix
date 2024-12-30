{ config, pkgs, ... }:
{
  imports = [ ../common.nix ];
  home = {
    packages = with pkgs; [

    ];
  };

  xdg.configFile."kitty" = {
    source = ../../dotfiles/kitty;
    target = "${config.xdg.configHome}/kitty";
    recursive = true;
  };
  xdg.configFile."ghostty" = {
    source = ../../dotfiles/ghostty;
    target = "${config.xdg.configHome}/ghostty";
    recursive = true;
  };
  xdg.configFile."sketchybar" = {
    source = ../../dotfiles/sketchybar;
    target = "${config.xdg.configHome}/sketchybar";
    recursive = true;
  };
  programs.zsh.profileExtra = ''
    eval $(/opt/homebrew/bin/brew shellenv)
  '';
}
