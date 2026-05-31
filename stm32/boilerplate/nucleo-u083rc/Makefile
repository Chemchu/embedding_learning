TARGET   = firmware
BUILD    = build
CHIP     = STM32U083RCTx
LDSCRIPT = STM32U083RCTX_FLASH.ld

CC      = arm-none-eabi-gcc
SIZE    = arm-none-eabi-size

CPU     = -mcpu=cortex-m0plus -mthumb -mfloat-abi=soft
DEFS    = -DSTM32U083xx -DUSE_HAL_DRIVER

CFLAGS  = $(CPU) $(DEFS) -Iinclude -Wall -ffunction-sections -fdata-sections -Os -g
ASFLAGS = $(CPU) $(DEFS) -x assembler-with-cpp
LDFLAGS = $(CPU) -T$(LDSCRIPT) -Wl,--gc-sections -Wl,-Map=$(BUILD)/$(TARGET).map \
          --specs=nano.specs --specs=nosys.specs

C_SRCS  = $(wildcard src/*.c)
C_SRCS += lib/system_stm32u0xx.c
C_SRCS += $(wildcard lib/hal/*.c)
C_SRCS += $(wildcard lib/bsp/*.c)

AS_SRCS = lib/startup_stm32u083xx.s

OBJS    = $(addprefix $(BUILD)/,$(C_SRCS:.c=.o))
OBJS   += $(addprefix $(BUILD)/,$(AS_SRCS:.s=.o))

.PHONY: all flash clean

all: $(BUILD)/$(TARGET).elf

$(BUILD)/$(TARGET).elf: $(OBJS)
	$(CC) $(OBJS) $(LDFLAGS) -o $@
	$(SIZE) $@

$(BUILD)/%.o: %.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD)/%.o: %.s
	@mkdir -p $(dir $@)
	$(CC) $(ASFLAGS) -c $< -o $@

flash: $(BUILD)/$(TARGET).elf
	probe-rs download --chip $(CHIP) $<

clean:
	rm -rf $(BUILD)
