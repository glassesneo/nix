{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      xsel
    ];
    shellAliases = {
      pbcopy = "xsel --clipboard --input";
      pbpaste = "xsel --clipboard --output";
    };
  };
}
