{ config, pkgs, lib, modulesPath, ... }:
with lib; {
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  config = {

    # Filesystems
    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
      autoResize = true;
    };

    # Bootloader
    boot.growPartition = true;
    boot.kernelParams = [ "console=ttyS0" ];
    boot.loader.grub.device = "/dev/sda";
    boot.loader.timeout = 15;

    # swapfile
    swapDevices = [{
      device = "/var/swapfile";
      size = (1024 * 4);
    }];

    # Locale settings
    i18n.defaultLocale = "en_US.UTF-8";
    console = {
      font = "Lat2-Terminus16";
      keyMap = "us";
    };

    # Openssh
    programs.ssh.startAgent = false;
    services.openssh = {
      enable = true;
      passwordAuthentication = false;
      startWhenNeeded = true;
      challengeResponseAuthentication = false;
      permitRootLogin = "yes";
    };

    # nix
    nix = {

      # Enable flakes
      package = pkgs.nixFlakes;

      # Save space by hardlinking store files
      autoOptimiseStore = true;

      # Clean up old generations after 30 days
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };

    };

    # Install some basic utilities
    environment.systemPackages =
      [ pkgs.git pkgs.docker-compose pkgs.ag pkgs.htop ];

    # Let 'nixos-version --json' know about the Git revision
    # of this flake.
    # system.configurationRevision = pkgs.lib.mkIf (self ? rev) self.rev;

    # Accept ACME terms
    security.acme.acceptTerms = true;

  };
}
