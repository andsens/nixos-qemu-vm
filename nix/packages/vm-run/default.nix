{
  lib,
  writeShellScriptBin,
  coreutils,
  virt-viewer,
  procps,
  ...
}:
writeShellScriptBin "vm-run" ''
  export PATH="${
    lib.makeBinPath [
      coreutils
      virt-viewer
      procps
    ]
  }:$PATH"
  exec ${./run} "$@"
''
