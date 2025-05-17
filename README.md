# swift_os

An operating system written in Swift.

## Prerequisites

- QEMU 9.0 or later
  - Arch Linux: `sudo pacman -S qemu-system-aarch64`
  - Fedora 41 or later: `sudo dnf install qemu-system-aarch64-core`
  - Fedora 40: Build from [source](https://www.qemu.org/download/#source)
  - Ubuntu 24.04/22.04: Build from [source](https://www.qemu.org/download/#source)
  - Debian 12: `sudo apt install -t bookwarm-backports qemu-system-arm` (you need to [add backports to `sources.list`](https://backports.debian.org/Instructions/#index2h2))
  - macOS 14 or later: `brew install qemu`
- [Swiftly](https://www.swift.org/install/)
- Swift toolchain: Just run `swiftly install` after installing Swiftly

## Building for emulators

```shell
swift build -c release --triple aarch64-none-none-elf --toolset toolset.json
```

> [!TIP]
> If you want to reduce the binary size significantly, you can use a `-experimental-hermetic-seal-at-link` flag. However, when using it, swift_os may not work as expected.
>
> ```shell
> swift build -c release --triple aarch64-none-none-elf --toolset toolset.json --experimental-lto-mode=full -Xswiftc -experimental-hermetic-seal-at-link
> ```

## Running on QEMU

```shell
swift run -c release --triple aarch64-none-none-elf --toolset toolset.json
```

> [!TIP]
> If you want to reduce the binary size significantly, you can use a `-experimental-hermetic-seal-at-link` flag. However, when using it, swift_os may not work as expected.
>
> ```shell
> swift run -c release --triple aarch64-none-none-elf --toolset toolset.json --experimental-lto-mode=full -Xswiftc -experimental-hermetic-seal-at-link
> ```

## Building for real hardwares

```shell
swift build -c release --triple aarch64-none-none-elf --toolset toolset.json
llvm-objcopy .build/release/Kernel -O binary .build/kernel8.img
```

> [!TIP]
> If you want to reduce the binary size significantly, you can use a `-experimental-hermetic-seal-at-link` flag. However, when using it, swift_os may not work as expected.
>
> ```shell
> swift build -c release --triple aarch64-none-none-elf --toolset toolset.json --experimental-lto-mode=full -Xswiftc -experimental-hermetic-seal-at-link
> llvm-objcopy .build/release/Kernel -O binary .build/kernel8.img
> ```

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
