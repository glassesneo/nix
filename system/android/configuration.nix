{ config, lib, pkgs, ... }:
let
  username = "nix-on-droid";
  hostname = "localhost";
in
  {
    imports = [
      ../common.nix
    ];

    nix = {
      settings = {
        # substituers that will be considered before the official ones(https://cache.nixos.org)
        substituters = [
          "https://mirror.sjtu.edu.cn/nix-channels/store"
          "https://nix-community.cachix.org"
        ];
        trusted-users = [ username ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
        builders-use-substitutes = true;
      };
      gc = {
        automatic = true;
        interval = { Weekday = 0; Hour = 0; Minute = 0; };
        options = "--delete-older-than 7d";
      };
    };

    time.timeZone = "Japan/Tokyo";
  }
