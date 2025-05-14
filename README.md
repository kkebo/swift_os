# swift_os

An operating system written in Swift.

## Prerequisites

- QEMU 9.0 or later
  - Arch Linux: `sudo pacman -S qemu-system-aarch64`
  - Fedora 41 or later: `sudo dnf install qemu-system-aarch64-core`
  - Fedora 40: Build from [source](https://www.qemu.org/download/#source)
  - Ubuntu 24.04/22.04: Build from [source](https://www.qemu.org/download/#source)
  - Debian 12: `sudo apt install -t bookwarm-backports qemu-system-arm` (you need to [add backports to `sources.list`](https://backports.debian.org/Instructions/#index2h2))
  - macOS 14: `brew install qemu`
- Swift (main development snapshot)
  - You can easily install the toolchain using [Swiftly](https://www.swift.org/install/).

    ```shell
    swiftly install
    ```

## Building for emulators

On Linux,

```shell
swift build -c release --triple aarch64-none-none-elf --toolset toolsets/linux.json
```

On macOS,

```shell
swift build -c release --triple aarch64-none-none-elf --toolset toolsets/macos.json
```

## Running on QEMU

On Linux,

```shell
swift run -c release --triple aarch64-none-none-elf --toolset toolsets/linux.json
```

On macOS,

```shell
swift run -c release --triple aarch64-none-none-elf --toolset toolsets/macos.json
```

## Building for real hardwares

On Linux,

```shell
swift build -c release --triple aarch64-none-none-elf --toolset toolsets/linux.json
llvm-objcopy .build/release/Kernel -O binary .build/kernel8.img
```

On macOS,

```shell
swift build -c release --triple aarch64-none-none-elf --toolset toolsets/macos.json
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
swift format lint -rp .
```
