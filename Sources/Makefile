OBJS := boot.o kernel.o lib.o
EXE := kernel.elf

TRIPLE := aarch64-none-none-elf
SWIFTC := swiftc
SWIFTC_FLAGS := -target $(TRIPLE) -enable-experimental-feature Embedded -wmo -Osize -Xfrontend -disable-stack-protector -no-allocations -parse-as-library -swift-version 6
CC := clang
CFLAGS := -target $(TRIPLE) -ffreestanding
AS := $(CC) -x assembler
ASFLAGS := -target $(TRIPLE) -c
LD := $(CC) -fuse-ld=lld
LDFLAGS := -nostdlib -Wl,-gc-sections -static

.PHONY: all clean

all: $(EXE)

$(EXE): linker.ld $(OBJS)
	$(LD) $(LDFLAGS) -Tlinker.ld $(OBJS) -o $@

%.o: %.swift
	$(SWIFTC) $(SWIFTC_FLAGS) -c $< -o $@

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

%.o: %.s
	$(AS) $(ASFLAGS) $< -o $@

clean:
	$(RM) $(OBJS) $(EXE)
