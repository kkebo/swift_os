LIB := .build/release/libKernel.a
EXE := kernel.elf
IMG := kernel8.img
MAP := kernel.map
LINKER_SCRIPT := linker.ld

TRIPLE := aarch64-none-none-elf
SWIFT := swift
SWIFT_BUILD_FLAGS := --triple $(TRIPLE) -c release -Xswiftc -Osize \
					 --experimental-lto-mode=full -Xswiftc -experimental-hermetic-seal-at-link
LD := clang -fuse-ld=lld
LDFLAGS := --target=$(TRIPLE) -nostdlib -static -Wl,--gc-sections,--print-gc-sections,--strip-all
OBJCOPY := llvm-objcopy
QEMU := qemu-system-aarch64

.PHONY: all
all: $(IMG)

$(EXE): Makefile $(LINKER_SCRIPT) $(LIB)
	$(LD) $(LDFLAGS) -T $(LINKER_SCRIPT) -Xlinker -Map=$(MAP) $(LIB) -o $@

$(IMG): Makefile $(EXE)
	$(OBJCOPY) $(EXE) -O binary $@

$(LIB): Makefile .swift-version Package.swift $(wildcard Package.resolved) Sources
	$(SWIFT) build $(SWIFT_BUILD_FLAGS)

.PHONY: run
run: $(IMG)
	$(QEMU) -machine raspi4b -kernel $(IMG) -serial stdio

.PHONY: clean
clean:
	$(RM) $(EXE) $(IMG) $(MAP)
	$(SWIFT) package clean

.PHONY: lint
lint:
	$(SWIFT) format lint -rp .

.PHONY: fmt
fmt:
	$(SWIFT) format format -rip .
