
{
  description = "NixOS config";

  inputs = {
  
  # Define Nixpkgs version 
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

  # Home Manager as a flake 
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, nixos-hardware, ... }:

    let 
    	system = "x86_64-linux";

    	pkgs = import nixpkgs {
		inherit system;
		config.allowUnfree = true;
	
	};
	username = "gray";


    in {

    	nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
		inherit system pkgs;
		modules = [
			./configuration.nix
			./hardware-configuration.nix

			home-manager.nixosModules.home-manager {
				home-manager.useUserPackages = true;

				home-manager.users.${username} = import ./home.nix;
			}


	#		nixos-hardware.nixosModules.framework-laptop-16
		];
	};
    };
}

