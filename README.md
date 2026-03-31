# nixos-qemu-vm

QEMU VM profiles and packages for setting up and running nixosConfigurations
as VMs.

## Usage

Begin by adding `nixos-qemu-vm` to your flake inputs:

```nix
# flake.nix
{
  inputs = {
    systems.url = "github:nix-systems/default-linux";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    qemu-vm = {
      url = "github:andsens/nixos-qemu-vm";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
```

To run your normal host configuration in a VM, create a new NixOS configuration
and include both the setup and hardware profiles:

```nix
# configurations/vm-prebuilt.nix
{ inputs, ... }:
{
  imports = [
    inputs.qemu-vm.nixosModules.qemuSetup
    inputs.qemu-vm.nixosModules.qemuHardware
  ];
  config = {
    system.stateVersion = "25.11";
    nixpkgs.hostPlatform = "x86_64-linux";
  };
}
```

Add the configuration to your `flake.nix`

```nix
# flake.nix
{
  outputs = { self, nixpkgs, ... }: {
    nixosConfigurations = {
      prebuilt = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [
          ./configurations/configuration.nix
          ./configurations/vm-prebuilt.nix
        ];
      };
    };
  };
}
```

Then add a package which can start the VM when run:

```nix
# flake.nix
{
  outputs = { self, nixpkgs, ... }: {
    packages = {
      prebuilt = inputs.qemu-vm.lib.mkVMRunner {
        system = "x86_64-linux";
        vmName = "prebuilt-vm";
        nixosConfiguration = self.nixosConfigurations.prebuilt-vm;
      };
    };
  };
}
```

You can now run your VM with `nix run '.#prebuilt'`.
