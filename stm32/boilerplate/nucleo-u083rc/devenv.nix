{pkgs, ...}: {
  packages = [
    pkgs.gcc-arm-embedded
    pkgs.gnumake
    pkgs.probe-rs-tools
  ];

  enterShell = ''
    # Sentinel: real file means headers already copied; symlink or missing triggers (re)population
    if [ -L "include/stm32u0xx_hal.h" ] || [ ! -f "include/stm32u0xx_hal.h" ]; then
      if [ ! -d "cube_u0" ]; then
        echo "[devenv] Cloning STM32CubeU0..."
        git clone -q -c advice.detachedHead=false --depth 1 \
          --recurse-submodules --shallow-submodules \
          -b v1.3.0 https://github.com/STMicroelectronics/STM32CubeU0.git cube_u0
      fi

      echo "[devenv] Copying headers into include/..."
      mkdir -p include
      cp cube_u0/Drivers/CMSIS/Core/Include/*.h                    include/
      cp cube_u0/Drivers/CMSIS/Device/ST/STM32U0xx/Include/*.h     include/
      cp cube_u0/Drivers/STM32U0xx_HAL_Driver/Inc/*.h              include/
      cp cube_u0/Drivers/STM32U0xx_HAL_Driver/Inc/Legacy/*.h       include/
      cp cube_u0/Drivers/BSP/STM32U0xx_Nucleo/*.h                  include/

      # hal_conf.h is not in Inc/ — create it from the template (preserved across re-runs)
      if [ ! -f "include/stm32u0xx_hal_conf.h" ]; then
        cp cube_u0/Drivers/STM32U0xx_HAL_Driver/Inc/stm32u0xx_hal_conf_template.h \
           include/stm32u0xx_hal_conf.h
        echo "[devenv] Created include/stm32u0xx_hal_conf.h from template."
      fi

      echo "[devenv] Removing cube_u0..."
      rm -rf cube_u0
      echo "[devenv] include/ ready."
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
