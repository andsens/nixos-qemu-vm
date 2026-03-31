{
  description = "NixOS Qemu VM setup";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    systems.url = "github:nix-systems/default-linux";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };
  outputs =
    {
      systems,
      flake-parts,
      nixpkgs,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } (
      {
        flake-parts-lib,
        self,
        lib,
        ...
      }:
      {
        systems = import systems;
        flake = {
          lib = {
            mkVMRunner =
              {
                vmName,
                nixosConfiguration,
                system,
              }:
              (import inputs.nixpkgs { inherit system; }).writeShellScriptBin vmName ''
                exec ${
                  lib.getExe self.packages.${system}.vm-run
                } ${vmName} ${lib.escapeShellArg (lib.getExe nixosConfiguration.config.system.build.vm)}
              '';
          };
          nixosModules = {
            qemuHardware = ./nix/profiles/qemu-hardware.nix;
            qemuSetup = ./nix/profiles/qemu-setup.nix;
          };
        };
        perSystem =
          { pkgs, ... }:
          {
            packages.vm-run = pkgs.callPackage ./nix/packages/vm-run pkgs;
          };
      }
    );
}
