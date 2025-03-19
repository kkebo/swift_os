EXE := kernel.elf
IMG := kernel8.img
MAP := kernel.map

TRIPLE := aarch64-none-none-elf
SWIFT := swift
SWIFT_BUILD_FLAGS := --triple $(TRIPLE) -c release -Xswiftc -Osize \
					 --experimental-lto-mode=full -Xswiftc -experimental-hermetic-seal-at-link
LD := clang -fuse-ld=lld
LDFLAGS := --target=$(TRIPLE) -nostdlib -static -Wl,--gc-sections,--print-gc-sections,--strip-all,--allow-multiple-definition
OBJCOPY := llvm-objcopy
QEMU := qemu-system-aarch64

.PHONY: all
all: $(IMG)

$(EXE): linker.ld swift
	$(LD) $(LDFLAGS) -T linker.ld -Xlinker -Map=$(MAP) .build/release/libKernel.a -o $@

$(IMG): $(EXE)
	$(OBJCOPY) $< -O binary $@

.PHONY: swift
swift:
	$(SWIFT) build $(SWIFT_BUILD_FLAGS)

.PHONY: run
run: all
	$(QEMU) -machine raspi4b -kernel $(IMG) -serial stdio

.PHONY: clean
clean:
	$(RM) $(EXE) $(IMG) $(MAP)
	$(SWIFT) package clean
