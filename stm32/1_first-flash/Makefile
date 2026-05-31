CFLAGS  ?=  -W -Wall -Wextra -Werror -Wundef -Wshadow -Wdouble-promotion \
            -Wformat-truncation -fno-common -Wconversion \
            -g3 -Os -ffunction-sections -fdata-sections \
            -I. -Iinclude -Icmsis_core/CMSIS/Core/Include -Icmsis_u0/Include \
            -mcpu=cortex-m0plus -mthumb -mfloat-abi=soft $(EXTRA_CFLAGS)
LDFLAGS ?= -Tlink.ld -nostartfiles -nostdlib --specs nano.specs -lc -lgcc -Wl,--gc-sections -Wl,-Map=$@.map
SOURCES = main.c syscalls.c
SOURCES += cmsis_u0/Source/Templates/gcc/startup_stm32u083xx.s # ST startup file. Compiler-dependent!

ifeq ($(OS),Windows_NT)
  RM = cmd /C del /Q /F
else
  RM = rm -rf
endif

build: firmware.bin

firmware.elf: cmsis_core cmsis_u0 hal.h link.ld Makefile $(SOURCES) 
	arm-none-eabi-gcc $(SOURCES) $(CFLAGS) $(CFLAGS_EXTRA) $(LDFLAGS) -o $@

firmware.bin: firmware.elf
	arm-none-eabi-objcopy -O binary $< $@

CHIP ?= STM32U083RC

flash: firmware.bin
	probe-rs download --chip $(CHIP) --binary-format bin --base-address 0x08000000 $<

cmsis_core:
	git clone -q -c advice.detachedHead=false --depth 1 -b v6.3.0 https://github.com/ARM-software/CMSIS_6 $@

cmsis_u0:
	git clone -q -c advice.detachedHead=false --depth 1 -b v1.3.0 https://github.com/STMicroelectronics/cmsis_device_u0 $@

clean:
	$(RM) firmware.* cmsis_*
