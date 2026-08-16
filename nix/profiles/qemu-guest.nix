{ ... }:
{ lib, pkgs, ... }:
{
  config = {
    environment.systemPackages = [ pkgs.spice-vdagent ];
    boot.initrd.availableKernelModules = [
      "virtio_pci"
      "uhci_hcd"
      "ehci_pci"
      "ahci"
      "sr_mod"
      "virtio_blk"
    ];
    networking.useDHCP = lib.mkDefault true;
  };
}
