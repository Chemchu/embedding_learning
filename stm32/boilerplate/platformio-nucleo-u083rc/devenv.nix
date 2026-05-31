{pkgs, ...}: {
  packages = [
    pkgs.gcc-arm-embedded
    pkgs.gnumake
    pkgs.probe-rs-tools
  ];

  enterShell = ''
    if [ ! -d "cube_u0" ]; then
      echo "[devenv] Cloning STM32CubeU0 (first-time setup)..."
      git clone -q -c advice.detachedHead=false --depth 1 \
        --recurse-submodules --shallow-submodules \
        -b v1.3.0 https://github.com/STMicroelectronics/STM32CubeU0.git cube_u0
    fi

    sysroot=$(arm-none-eabi-gcc -print-sysroot)
    gcc_include=$(arm-none-eabi-gcc -print-file-name=include)
    cat > .clangd <<CLANGD
CompileFlags:
  Compiler: arm-none-eabi-gcc
  Add:
    - -I.
    - -Iinclude
    - -Isrc
    - -Icube_u0/Drivers/CMSIS/Core/Include
    - -Icube_u0/Drivers/CMSIS/Device/ST/STM32U0xx/Include
    - -Icube_u0/Drivers/STM32U0xx_HAL_Driver/Inc
    - -Icube_u0/Drivers/STM32U0xx_HAL_Driver/Inc/Legacy
    - --target=arm-none-eabi
    - -mcpu=cortex-m0plus
    - -mthumb
    - -mfloat-abi=soft
    - -DSTM32U083xx
    - -DUSE_HAL_DRIVER
    - -nostdinc
    - -isystem$sysroot/include
    - -isystem$gcc_include
CLANGD
    echo "[devenv] .clangd generated."
  '';
}
