# swift_os

An operating system written in Swift.

## Modules

- `Boot` — Minimal boot code before entering Swift.
- `Kernel` — Kernel executable and system entry point.
- `KernelCore` — Architecture- and platform-independent kernel logic (scheduler, memory management, core services).
- `Hardware` — Hardware abstraction layer defining device interfaces independent of CPU architecture and platform (console, timer, framebuffer, etc.).
- CPU architecture support
  - `ArchAArch64` - (planned) AArch64 CPU support (exceptions, MMU, vector tables, system registers).
  - `ArchX8664` - (planned) x86_64 CPU support (IDT, paging, interrupts).
- Platform support
  - `RaspberryPi` — Raspberry Pi platform implementation (UART, mailbox, framebuffer, interrupt controller).
- `KernLibc` — Minimal libc for kernel space.
- `AppLibc` — Minimal libc for user space.
- `AsmSupport` — Assembly helper functions.
- `LinkerSupport` — Swift bindings for linker-defined symbols.

## Prerequisites

- QEMU 9.0 or later
  - Arch Linux: `sudo pacman -S qemu-system-aarch64`
  - Fedora 41 or later: `sudo dnf install qemu-system-aarch64-core`
  - Fedora 40: Build from [source](https://www.qemu.org/download/#source)
  - Ubuntu 24.04/22.04: Build from [source](https://www.qemu.org/download/#source)
  - Debian 13 or later: `run0 apt install qemu-system-arm`
  - Debian 12: `sudo apt install -t bookwarm-backports qemu-system-arm` (you need to [add backports to `sources.list`](https://backports.debian.org/Instructions/#index2h2))
  - macOS 14 or later: `brew install qemu`
- [Swiftly](https://www.swift.org/install/)
- Swift toolchain: Just run `swiftly install` after installing Swiftly

## Building for emulators

```shell
swift build -c release --triple aarch64-none-none-elf --toolset toolset.json --build-system native
```

## Running on QEMU

```shell
swift run -c release --triple aarch64-none-none-elf --toolset toolset.json --build-system native
```

## Building for real hardwares

```shell
swift build -c release --triple aarch64-none-none-elf --toolset toolset.json --build-system native
llvm-objcopy .build/release/Kernel -O binary .build/kernel8.img
```

## Cleaning build outputs

```shell
swift package clean
```

## swift-format

This project is using [swift-format](https://github.com/swiftlang/swift-format) for formatting and linting.

Format:

```shell
swift format format -rip .
```

Lint:

```shell
swift format lint -rsp .
```
