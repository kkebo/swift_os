EXE := Sources/kernel.elf

QEMU := qemu-system-aarch64

.PHONY: all run clean

all:
	$(MAKE) -C Sources

run: all
	$(QEMU) -machine virt -cpu cortex-a57 -kernel $(EXE) -nographic

clean:
	$(MAKE) -C Sources clean
