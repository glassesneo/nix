{ config, lib, pkgs, ... }:
let
  username = "nix-on-droid";
  hostname = "localhost";
in
  {
    system.stateVersion = "23.11";

    nix.extraOptions = ''
      experimental-features = nix-command flakes
    '';
    time.timeZone = "Japan/Tokyo";
  }
