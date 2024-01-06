# swift_os

An operating system written in Swift.

## Prerequisites

- GNU make (If you use Arch Linux, do `sudo pacman -S make`)
- qemu (If you use Arch Linux, do `sudo pacman -S qemu-system-aarch64`)
- Swift trunk development (main) toolchain (because Swift Embedded is used)

On Linux, you can easily install the Swift toolchain using [swiftly](https://swift-server.github.io/swiftly/).

```shell
curl -L https://swift-server.github.io/swiftly/swiftly-install.sh | bash
swiftly install main-snapshot
```

## Building

```shell
make
```

## Cleaning build outputs

```shell
make clean
```

## Running (QEMU)

```shell
make run
```
