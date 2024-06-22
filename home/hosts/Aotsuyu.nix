{ pkgs, commonPackages }:
{
  home = {
    packages = with pkgs; [
      xsel
    ] ++ commonPackages;
    shellAliases = {
      pbcopy = "xsel --clipboard --input";
      pbpaste = "xsel --clipboard --output";
    };
  };
  programs.zsh.profileExtra = ''
  eval $(/opt/homebrew/bin/brew shellenv)
  '';
}
