{ pkgs, commonPackages }:
{
  home = {
    packages = with pkgs; [] ++ commonPackages;
  };
}
