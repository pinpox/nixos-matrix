{
  description = "Workadventure hosts";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;
  };

  outputs = { self, ... }@inputs:
    with inputs;
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
      };

      lib = nixpkgs.lib;
    in {

      # NixOS system configuration. At this point, we only have one host.
      nixosConfigurations = {
        lounge-rocks = nixpkgs.lib.nixosSystem {
          inherit lib pkgs system;
          modules = [ ./configuration.nix ];
        };
      };
    };
}
