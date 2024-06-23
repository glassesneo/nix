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
      hostname = "Oboro";
      specialArgs =
        inputs
        // {
          inherit username useremail hostname;
        };

      commonNixOSConfigurations = {
        system = "x86_64-linux";
        modules = [
          ./system/nixos/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = specialArgs;
            home-manager.verbose = true;
            home-manager.users."${username}" = import ./home/home.nix;
          }
        ];
      };

      commonDarwinConfigurations = {
          inherit specialArgs;
        system = "aarch64-darwin";
        modules = [
          ./system/darwin/configuration.nix
          ./system/darwin/system.nix
          ./system/darwin/apps.nix
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
          "Narukami" = inputs.nixpkgs.lib.nixosSystem commonNixOSConfigurations;
        };
        darwinConfigurations = {
          "Oboro" = nix-darwin.lib.darwinSystem commonDarwinConfigurations;
        };
        homeConfigurations."${username}" = home-manager.lib.homeManagerConfiguration {
          extraSpecialArgs = specialArgs;
          pkgs = nixpkgs.legacyPackages."${system}";
          modules = [ ./home/home.nix ];
        };
      };
}
