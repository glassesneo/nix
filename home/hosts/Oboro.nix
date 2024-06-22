{ pkgs, commonPackages }:
{
  home = {
    packages = with pkgs; [
      xsel
    ] ++ commonPackages;
  };
}
