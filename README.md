# swift_os

An operating system written in Swift.

## Prerequisites

- Make
  - Arch Linux: `sudo pacman -S make`
  - Fedora 40: `sudo dnf install make`
  - Ubuntu 22.04: `sudo apt install make`
  - Debian 12: `sudo apt install make`
  - macOS 14: bulit-in (`/usr/bin/make`)
- llvm-objcopy
  - Arch Linux: `sudo pacman -S llvm`
  - Fedora 40: `sudo dnf install llvm`
  - Ubuntu 22.04: `sudo apt install llvm`
  - Debian 12: `sudo apt install llvm`
  - macOS 14: `brew install llvm` and add `/opt/homebrew/opt/llvm/bin` to your `$PATH`
- QEMU 9.0 or later
  - Arch Linux: `sudo pacman -S qemu-system-aarch64`
  - Fedora 41 or later: `sudo dnf install qemu-system-aarch64-core`
  - Fedora 40: Build from [source](https://www.qemu.org/download/#source)
  - Ubuntu 24.04: Build from [source](https://www.qemu.org/download/#source)
  - Ubuntu 22.04: Build from [source](https://www.qemu.org/download/#source)
  - Debian 12: `sudo apt install -t bookwarm-backports qemu-system-arm` (you need to [add backports to `sources.list`](https://backports.debian.org/Instructions/#index2h2))
  - macOS 14: `brew install qemu`
- Swift (main development snapshot)
  - You can easily install the toolchain using [Swiftly](https://www.swift.org/install/).

    ```shell
    swiftly install main-snapshot
    swiftly use main-snapshot
    ```

## Building

```shell
make
```

## Cleaning build outputs

```shell
make clean
```

## Running on QEMU

```shell
make run
```
