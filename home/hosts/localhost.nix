{ pkgs, ... }:
{
  imports = [
    ../common.nix
  ];
  home = {
    packages = with pkgs; [
      openssh
      iproute2
      xsel
    ];
    shellAliases = {
      pbcopy = "xsel --clipboard --input";
      pbpaste = "xsel --clipboard --output";
    };
  };
}
