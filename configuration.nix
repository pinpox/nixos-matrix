{ config, pkgs, lib, ... }:
with lib; {
  imports =
    [ ./modules/base.nix ];

  config = {
    # Hostname, should match the flake output name
    networking.hostName = "nixos-matrix";
    security.acme.email = "acme@pablo.tools";


    # Users/SSH-keys to add. Make sure to authorize the CI secret key in order
    # to be able to use automatic deployments.
    users = {
      users.root = {
        openssh.authorizedKeys.keyFiles = [
          (pkgs.fetchurl {
            url = "https://github.com/pinpox.keys";
            hash = "sha256-Cf/PSZemROU/Y0EEnr6A+FXE0M3+Kso5VqJgomGST/U=";
          })
        ];
      };
    };
  };
}
