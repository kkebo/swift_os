# swift_os

An operating system written in Swift.

## Prerequisites

- Make
  - Arch Linux: `sudo pacman -S make`
  - Fedora 40: `sudo dnf install make`
  - Ubuntu 22.04: `sudo apt install make`
  - macOS 14: bulit-in (`/usr/bin/make`)
- llvm-objcopy
  - Arch Linux: `sudo pacman -S llvm`
  - Fedora 40: `sudo dnf install llvm`
  - Ubuntu 22.04: `sudo apt install llvm`
  - macOS 14: `brew install llvm` and add `/opt/homebrew/opt/llvm/bin` to your `$PATH`
- QEMU 9.0 or later
  - Arch Linux: `sudo pacman -S qemu-system-aarch64`
  - Fedora Rawhide: `sudo dnf install qemu-system-aarch64-core`
  - Fedora 40: Build from [source](https://www.qemu.org/download/#source)
  - Ubuntu 22.04: ~~`sudo apt install qemu-system-arm`~~ Build from [source](https://www.qemu.org/download/#source)
  - macOS 14: `brew install qemu`
- Swift (6.0 snapshot)
  - On Linux, you can easily install the toolchain using [swiftly](https://swift-server.github.io/swiftly/).

    ```shell
    curl -L https://swift-server.github.io/swiftly/swiftly-install.sh | bash
    swiftly install 6.0-snapshot
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
