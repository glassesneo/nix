{
  description = "Neo's nix configuration";

  nixConfig = {
    substituters = [
      # Query the mirror of USTC first, and then the official cache.
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://cache.nixos.org"
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, nixos-hardware, nix-darwin, home-manager }:
    let
      username = builtins.getEnv "USER";
      useremail = "glassesneo@protonmail.com";
      system = builtins.currentSystem;
      hostname = "Usurai";
      specialArgs =
        inputs
        // {
          inherit username useremail hostname;
        };

      commonNixOSConfigurations = {
        system = "x86_64-linux";
        modules = [
          ./nixos/configuration.nix
        ];
      };

      commonDarwinConfigurations = {
          inherit specialArgs;
        system = "aarch64-darwin";
        modules = [
          ./darwin/nix-core.nix
          ./darwin/system.nix
          ./darwin/host-users.nix
          ./darwin/apps.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = specialArgs;
            home-manager.verbose = true;
            home-manager.users."${username}" = import ./home/home.nix;
          }
        ];
      };

    in
      {
        nixosConfigurations = {
          "Aotsuyu" = inputs.nixpkgs.lib.nixosSystem commonNixOSConfigurations;
        };
        darwinConfigurations = {
          "Usurai" = nix-darwin.lib.darwinSystem commonDarwinConfigurations;
        };
        homeConfigurations."${username}" = home-manager.lib.homeManagerConfiguration {
          extraSpecialArgs = specialArgs;
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [ ./home/home.nix ];
        };
      };
}
