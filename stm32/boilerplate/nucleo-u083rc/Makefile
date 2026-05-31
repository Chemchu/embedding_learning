CUBE    = cube_u0
HAL_SRC = $(CUBE)/Drivers/STM32U0xx_HAL_Driver/Src

CFLAGS  ?= -W -Wall -Wextra -Wundef -Wshadow -Wdouble-promotion \
           -Wformat-truncation -fno-common -Wconversion \
           -g3 -Os -ffunction-sections -fdata-sections \
           -I. -Iinclude -Isrc \
           -I$(CUBE)/Drivers/CMSIS/Core/Include \
           -I$(CUBE)/Drivers/CMSIS/Device/ST/STM32U0xx/Include \
           -I$(HAL_SRC)/../Inc \
           -I$(HAL_SRC)/../Inc/Legacy \
           -mcpu=cortex-m0plus -mthumb -mfloat-abi=soft \
           -DSTM32U083xx -DUSE_HAL_DRIVER \
           $(EXTRA_CFLAGS)

LDFLAGS ?= -T$(CUBE)/Projects/NUCLEO-U083RC/Templates/STM32CubeIDE/STM32U083RCTX_FLASH.ld \
           -nostartfiles -nostdlib --specs nano.specs -lc -lgcc \
           -Wl,--gc-sections -Wl,-Map=$@.map

SOURCES  = src/main.c
SOURCES += $(CUBE)/Drivers/CMSIS/Device/ST/STM32U0xx/Source/Templates/gcc/startup_stm32u083xx.s
SOURCES += $(CUBE)/Drivers/CMSIS/Device/ST/STM32U0xx/Source/Templates/system_stm32u0xx.c
SOURCES += $(HAL_SRC)/stm32u0xx_hal.c
SOURCES += $(HAL_SRC)/stm32u0xx_hal_cortex.c
SOURCES += $(HAL_SRC)/stm32u0xx_hal_rcc.c
SOURCES += $(HAL_SRC)/stm32u0xx_hal_rcc_ex.c
SOURCES += $(HAL_SRC)/stm32u0xx_hal_pwr.c

ifeq ($(OS),Windows_NT)
  RM = cmd /C del /Q /F
else
  RM = rm -rf
endif

build: firmware.bin

firmware.elf: $(CUBE) Makefile $(SOURCES)
	arm-none-eabi-gcc $(SOURCES) $(CFLAGS) $(LDFLAGS) -o $@

firmware.bin: firmware.elf
	arm-none-eabi-objcopy -O binary $< $@

flash: firmware.elf
	probe-rs download --chip STM32U083RCTx $<

$(CUBE):
	git clone -q -c advice.detachedHead=false --depth 1 \
	  --recurse-submodules --shallow-submodules \
	  -b v1.3.0 https://github.com/STMicroelectronics/STM32CubeU0.git $@

clean:
	$(RM) firmware.*

distclean: clean
	$(RM) cube_*
