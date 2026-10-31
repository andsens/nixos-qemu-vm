{ inputs, ... }:
{
  pkgs,
  lib,
  ...
}:
{
  imports = [ "${inputs.nixpkgs}/nixos/modules/virtualisation/qemu-vm.nix" ];
  config = {
    services = {
      qemuGuest.enable = lib.mkDefault true;
      spice-autorandr.enable = lib.mkDefault true;
      spice-vdagentd.enable = lib.mkDefault true;
    };
    virtualisation = {
      memorySize = lib.mkDefault (8 * 1024);
      cores = lib.mkDefault 8;
      useSecureBoot = lib.mkDefault true;
      useEFIBoot = lib.mkDefault true;
      useBootLoader = lib.mkDefault true;
      efi.OVMF = lib.mkDefault pkgs.OVMFFull;
      tpm = {
        enable = lib.mkDefault true;
        deviceModel = lib.mkDefault "tpm-tis";
      };
      qemu = {
        virtioKeyboard = lib.mkDefault false;
        # The display (spice) comes from vm-run, so other runners like the NixOS test driver can bring their own
        options = [ "-vga none -device virtio-gpu" ];
      };
      sharedDirectories = {
        pwd = {
          # vm-run sets FLAKE_SRC, the start script always creates xchg
          source = lib.mkDefault ''"''${FLAKE_SRC:-$TMPDIR/xchg}"'';
          target = lib.mkDefault "/flake_src";
          securityModel = lib.mkDefault "none";
        };
      };
    };
  };
}
