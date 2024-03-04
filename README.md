# swift_os

An operating system written in Swift.

## Prerequisites

- Make
  - Arch Linux: `sudo pacman -S make`
  - Fedora: `sudo dnf install make`
  - Ubuntu: `sudo apt install make`
  - macOS: bulit-in (`/usr/bin/make`)
- llvm-objcopy
  - Arch Linux: `sudo pacman -S llvm`
  - Fedora: `sudo dnf install llvm`
  - Ubuntu: `sudo apt install llvm`
  - macOS: `brew install llvm` and add `/opt/homebrew/opt/llvm/bin` to your `$PATH`
- QEMU
  - Arch Linux: `sudo pacman -S qemu-system-aarch64`
  - Fedora: `sudo dnf install qemu-system-aarch64-core`
  - Ubuntu: `sudo apt install qemu-system-arm`
  - macOS: `brew install qemu`
- Swift trunk development (main) toolchain (because Swift Embedded is used)
  - On Linux, you can easily install the toolchain using [swiftly](https://swift-server.github.io/swiftly/).

    ```shell
    curl -L https://swift-server.github.io/swiftly/swiftly-install.sh | bash
    swiftly install main-snapshot
    ```

## Building

```shell
make
```

> [!WARNING]
> If you used swiftly to install Swift, you have to modify `Makefile` until https://github.com/swift-server/swiftly/issues/92 is resolved.
>
> ```makefile
> SWIFT := swift-legacy-driver
> ```

## Cleaning build outputs

```shell
make clean
```

## Running (QEMU)

```shell
make run
```
