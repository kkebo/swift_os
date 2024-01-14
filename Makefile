EXE := kernel.elf
IMG := kernel8.img

TRIPLE := aarch64-none-none-elf
SWIFT := swift
AS := clang -x assembler
ASFLAGS := -target $(TRIPLE) -c
LD := clang -fuse-ld=lld
LDFLAGS := -nostdlib -Wl,-gc-sections -static -lgcc
OBJCOPY := objcopy
QEMU := qemu-system-aarch64

.PHONY: all
all: $(IMG)

$(EXE): linker.ld boot.o swift
	$(LD) $(LDFLAGS) -T linker.ld boot.o .build/release/libKernel.a -o $@

$(IMG): $(EXE)
	$(OBJCOPY) $< -O binary $@

.PHONY: swift
swift:
	$(SWIFT) build --triple $(TRIPLE) -c release

%.o: %.s
	$(AS) $(ASFLAGS) $< -o $@

.PHONY: run
run: all
	$(QEMU) -machine raspi3b -kernel $(IMG) -serial stdio -display none

.PHONY: clean
clean:
	$(RM) boot.o $(EXE) $(IMG)
	$(SWIFT) package clean
