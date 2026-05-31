CFLAGS  ?=  -W -Wall -Wextra -Werror -Wundef -Wshadow -Wdouble-promotion \
            -Wformat-truncation -fno-common -Wconversion \
            -g3 -Os -ffunction-sections -fdata-sections \
            -I. -Iinclude \
            -Icube_u0/Drivers/CMSIS/Core/Include \
            -Icube_u0/Drivers/CMSIS/Device/ST/STM32U0xx/Include \
            -mcpu=cortex-m0plus -mthumb -mfloat-abi=soft $(EXTRA_CFLAGS)
LDFLAGS ?= -Tcube_u0/Projects/NUCLEO-U083RC/Templates/STM32CubeIDE/STM32U083RCTX_FLASH.ld -nostartfiles -nostdlib --specs nano.specs -lc -lgcc -Wl,--gc-sections -Wl,-Map=$@.map
SOURCES = main.c
SOURCES += cube_u0/Drivers/CMSIS/Device/ST/STM32U0xx/Source/Templates/gcc/startup_stm32u083xx.s

ifeq ($(OS),Windows_NT)
  RM = cmd /C del /Q /F
else
  RM = rm -rf
endif

build: firmware.bin

firmware.elf: cube_u0 Makefile $(SOURCES)
	arm-none-eabi-gcc $(SOURCES) $(CFLAGS) $(CFLAGS_EXTRA) $(LDFLAGS) -o $@

firmware.bin: firmware.elf
	arm-none-eabi-objcopy -O binary $< $@

flash: firmware.bin
	st-flash --reset write $< 0x8000000

cube_u0:
	git clone -q -c advice.detachedHead=false --depth 1 --recurse-submodules --shallow-submodules -b v1.3.0 https://github.com/STMicroelectronics/STM32CubeU0.git $@

clean:
	$(RM) firmware.* cube_*
