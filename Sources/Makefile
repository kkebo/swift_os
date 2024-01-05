OBJS := boot.o kernel.o lib.o
EXE := kernel.elf

SWIFTC := swiftc
SWIFTC_FLAGS := -target aarch64-none-none-elf -enable-experimental-feature Embedded -wmo -Osize -Xfrontend -disable-stack-protector -no-allocations -parse-as-library -swift-version 6
CFLAGS := -ffreestanding
LDFLAGS := -nostdlib

.PHONY: all clean

all: $(EXE)

$(EXE): linker.ld $(OBJS)
	$(LD) $(LDFLAGS) -Tlinker.ld $(OBJS) -o $@

%.o: %.swift
	$(SWIFTC) $(SWIFTC_FLAGS) -c $< -o $@

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

%.o: %.s
	$(AS) $< -o $@

clean:
	$(RM) $(OBJS) $(EXE)
