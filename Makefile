EXE := kernel.elf

TRIPLE := aarch64-none-none-elf
SWIFT := swift
AS := clang -x assembler
ASFLAGS := -target $(TRIPLE) -c
LD := clang -fuse-ld=lld
LDFLAGS := -nostdlib -Wl,-gc-sections -static
QEMU := qemu-system-aarch64

.PHONY: all
all: $(EXE)

$(EXE): linker.ld boot.o swift
	$(LD) $(LDFLAGS) -T linker.ld boot.o .build/release/libKernel.a -o $@

.PHONY: swift
swift:
	$(SWIFT) build --triple $(TRIPLE) -c release

%.o: %.s
	$(AS) $(ASFLAGS) $< -o $@

.PHONY: run
run: all
	$(QEMU) -machine virt -cpu cortex-a57 -kernel $(EXE) -nographic

.PHONY: clean
clean:
	$(RM) boot.o $(EXE)
	$(SWIFT) package clean
