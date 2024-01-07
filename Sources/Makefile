OBJS := boot.o kernel.o
EXE := kernel.elf

TRIPLE := aarch64-none-none-elf
SWIFTC := swiftc
SWIFTC_FLAGS := -target $(TRIPLE) -enable-experimental-feature Embedded -wmo -Osize -Xfrontend -no-allocations -parse-as-library -swift-version 6
AS := clang -x assembler
ASFLAGS := -target $(TRIPLE) -c
LD := clang -fuse-ld=lld
LDFLAGS := -nostdlib -Wl,-gc-sections -static

.PHONY: all clean

all: $(EXE)

$(EXE): linker.ld $(OBJS)
	$(LD) $(LDFLAGS) -Tlinker.ld $(OBJS) -o $@

%.o: %.swift
	$(SWIFTC) $(SWIFTC_FLAGS) -c $< -o $@

%.o: %.s
	$(AS) $(ASFLAGS) $< -o $@

clean:
	$(RM) $(OBJS) $(EXE)
