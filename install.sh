#!/bin/bash

dir="$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"

mkdir -p "${HOME}/.local/bin"
cp "${dir}"/bin/* "${HOME}/.local/bin/"

mkdir -p "${HOME}/.config/ckb-animation"
cp -r "${dir}"/config/* "${HOME}/.config/ckb-animation/"
