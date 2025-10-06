#!/bin/bash

set -euxo pipefail

sudo apt-get update && sudo apt-get install --no-install-recommends -y libcurl4-openssl-dev

curl -O "https://download.swift.org/swiftly/linux/swiftly-$(uname -m).tar.gz"
tar zxf "swiftly-$(uname -m).tar.gz"
./swiftly init -y --skip-install -n
# shellcheck disable=SC1091
. "$HOME/.local/share/swiftly/env.sh"
hash -r

echo "PATH=$PATH" >> "$GITHUB_ENV" && echo "SWIFTLY_HOME_DIR=$SWIFTLY_HOME_DIR" >> "$GITHUB_ENV" && echo "SWIFTLY_BIN_DIR=$SWIFTLY_BIN_DIR" >> "$GITHUB_ENV" && echo "SWIFTLY_TOOLCHAINS_DIR=$SWIFTLY_TOOLCHAINS_DIR" >> "$GITHUB_ENV"

swiftly install -y
