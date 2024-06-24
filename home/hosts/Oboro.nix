{ pkgs, ... }:
{
  imports = [
    ../common.nix
  ];
  home = {
    packages = with pkgs; [

    ];
  };
  programs.zsh.profileExtra = ''
  eval $(/opt/homebrew/bin/brew shellenv)
  '';
}
