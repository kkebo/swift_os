# swift_os

An operating system written in Swift.

## Prerequisites

- Make
  - Arch Linux: `sudo pacman -S make`
  - Fedora 40 or later: `sudo dnf install make`
  - Ubuntu 24.04/22.04: `sudo apt install make`
  - Debian 12: `sudo apt install make`
  - macOS 14: bulit-in (`/usr/bin/make`)
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
