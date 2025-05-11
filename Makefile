EXE := .build/release/Kernel
IMG := .build/kernel8.img
TOOLSET := toolset.json

TRIPLE := aarch64-none-none-elf
SWIFT := swift
SWIFT_BUILD_FLAGS := --triple $(TRIPLE) --toolset $(TOOLSET) -c release -Xswiftc -Osize \
                     --experimental-lto-mode=full -Xswiftc -experimental-hermetic-seal-at-link
OBJCOPY := llvm-objcopy
QEMU := qemu-system-aarch64

.PHONY: all
all: $(IMG)

$(IMG): Makefile $(EXE)
	$(OBJCOPY) $(EXE) -O binary $@

$(EXE): Makefile swift

.PHONY: swift
swift:
	$(SWIFT) build $(SWIFT_BUILD_FLAGS)

.PHONY: run
run: $(IMG)
	$(QEMU) -machine raspi4b -kernel $(IMG) -serial stdio

.PHONY: clean
clean:
	$(SWIFT) package clean

.PHONY: lint
lint:
	$(SWIFT) format lint -rp .

.PHONY: fmt
fmt:
	$(SWIFT) format format -rip .
