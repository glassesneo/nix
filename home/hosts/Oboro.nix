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
  programs.zsh.profileExtra = ''
    eval $(/opt/homebrew/bin/brew shellenv)
  '';
}
