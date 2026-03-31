{
  inputs,
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
        options = [
          "-vga none -device virtio-gpu -display none"
          "-spice disable-ticketing=on,port=5930,addr=127.0.0.1"
          "-device virtio-serial-pci"
          "-chardev spicevmc,id=vdagent0,name=vdagent"
          "-device virtserialport,chardev=vdagent0,name=com.redhat.spice.0"
          "-chardev spiceport,id=webdav0,name=org.spice-space.webdav.0"
          "-device virtserialport,chardev=webdav0,name=org.spice-space.webdav.0"
        ];
      };
      sharedDirectories = {
        pwd = {
          source = lib.mkDefault ''"$FLAKE_SRC"'';
          target = lib.mkDefault "/flake_src";
          securityModel = lib.mkDefault "none";
        };
      };
    };
  };
}
