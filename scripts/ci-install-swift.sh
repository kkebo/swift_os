#!/bin/bash

set -euxo pipefail

install_swiftly_macos() {
  curl -O https://download.swift.org/swiftly/darwin/swiftly.pkg
  installer -pkg swiftly.pkg -target CurrentUserHomeDirectory
  ~/.swiftly/bin/swiftly init -y --skip-install -n
  # shellcheck source=/dev/null
  . "$HOME/.swiftly/env.sh"
  hash -r
}

install_swiftly_linux() {
  curl -O "https://download.swift.org/swiftly/linux/swiftly-$(uname -m).tar.gz"
  tar zxf "swiftly-$(uname -m).tar.gz"
  ./swiftly init -y --skip-install -n
  # shellcheck source=/dev/null
  . "$HOME/.local/share/swiftly/env.sh"
  hash -r
}

if [[ "$(uname)" == "Darwin" ]]; then
  install_swiftly_macos
elif [[ -f /etc/os-release ]]; then
  # shellcheck source=/etc/os-release
  . /etc/os-release
  if [[ "$NAME" == "Ubuntu" ]]; then
    sudo apt-get update && sudo apt-get install --no-install-recommends -y libcurl4-openssl-dev
    install_swiftly_linux
  else
    echo "Unsupported Linux Distribution: $NAME"
    exit 1
  fi
else
  echo "Unsupported OS: $(uname)"
  exit 1
fi

echo "PATH=$PATH" >> "$GITHUB_ENV" && echo "SWIFTLY_HOME_DIR=$SWIFTLY_HOME_DIR" >> "$GITHUB_ENV" && echo "SWIFTLY_BIN_DIR=$SWIFTLY_BIN_DIR" >> "$GITHUB_ENV" && echo "SWIFTLY_TOOLCHAINS_DIR=$SWIFTLY_TOOLCHAINS_DIR" >> "$GITHUB_ENV"

swiftly install -y
