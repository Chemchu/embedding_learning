{pkgs, ...}: {
  packages = [
    pkgs.gcc-arm-embedded
    pkgs.gnumake
    pkgs.probe-rs-tools
  ];

  # Generate .clangd with the actual nix store paths from the active toolchain.
  enterShell = ''
        sysroot=$(arm-none-eabi-gcc -print-sysroot)
        gcc_include=$(arm-none-eabi-gcc -print-file-name=include)
        cat > .clangd <<CLANGD
    CompileFlags:
      Compiler: arm-none-eabi-gcc
      Add:
        - -I.
        - -Icmsis_core/CMSIS/Core/Include
        - -Icmsis_u0/Include
        - --target=arm-none-eabi
        - -mcpu=cortex-m0plus
        - -mthumb
        - -mfloat-abi=soft
        - -DSTM32U083xx
        - -nostdinc
        - -isystem$sysroot/include
        - -isystem$gcc_include
    CLANGD
  '';
}
