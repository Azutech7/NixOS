{
    description = "Azutech NixOS Rice";

    inputs = {
        # NixOS
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

        # Home Manager
        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";

        # Modules
        #hyprland.url = "github:hyprwm/Hyprland";
        #cosmic.url = "github:lilyinstarlight/nixos-cosmic";
    };

    outputs = { self, nixpkgs, home-manager, ... }@inputs: {

        #####################
        #### HOSTS BEGIN ####
        #####################

        /* TEMPLATE
        nixosConfigurations.<HOST_NAME> = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";

            specialArgs = { inherit inputs; }; 

            modules = [
                ./hosts/<HOST_NAME>/config.nix
                
                ./nixos-modules/manifest.nix

                home-manager.nixosModules.home-manager
                {
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;

                    home-manager.extraSpecialArgs = { inherit inputs; };

                    home-manager.sharedModules = [
                        ./home-modules/manifest.nix
                    ];

                    home-manager.users = {
                        home-manager.users = {
                            <USER_NAME> = {
                                imports =  [./users/<USER_NAME>/config.nix];
                                home.username = inputs.nixpkgs.lib.mkForce "<USER_NAME>";
                                home.homeDirectory = inputs.nixpkgs.lib.mkForce "/home/<USER_NAME>";
                                home.stateVersion = inputs.nixpkgs.lib.mkForce "25.11";
                            };
                        };
                    };

                }
            ];
        };
        */

        nixosConfigurations.tyche = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";

            specialArgs = { inherit inputs; }; 

            modules = [
                ./hosts/tyche/config.nix
                
                ./nixos-modules/manifest.nix

                home-manager.nixosModules.home-manager
                {
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;

                    home-manager.extraSpecialArgs = { inherit inputs; };

                    home-manager.sharedModules = [
                        ./home-modules/manifest.nix
                    ];

                    home-manager.users = {
                        home-manager.users = {
                            azutech = {
                                imports =  [./users/azutech/config.nix];
                                home.username = inputs.nixpkgs.lib.mkForce "azutech";
                                home.homeDirectory = inputs.nixpkgs.lib.mkForce "/home/azutech";
                                home.stateVersion = inputs.nixpkgs.lib.mkForce "25.11";
                            };
                        };
                    };

                }
            ];
        };

        nixosConfigurations.atlas = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";

            specialArgs = { inherit inputs; }; 

            modules = [
                ./hosts/atlas/config.nix
                
                ./nixos-modules/manifest.nix

                home-manager.nixosModules.home-manager
                {
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;

                    home-manager.extraSpecialArgs = { inherit inputs; };

                    home-manager.sharedModules = [
                        ./home-modules/manifest.nix
                    ];

                    home-manager.users = {
                        server-manager = {
                            imports =  [./users/server-manager/config.nix];
                            home.username = inputs.nixpkgs.lib.mkForce "server-manager";
                            home.homeDirectory = inputs.nixpkgs.lib.mkForce "/home/server-manager";
                            home.stateVersion = inputs.nixpkgs.lib.mkForce "25.11";
                        };
                    };

                }
            ];
        };

        ###################
        #### HOSTS END ####
        ###################

    };
}
