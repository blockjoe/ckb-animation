#!/bin/bash

PARAMS=""

while (( "$#" )); do
  case "$1" in
    -f|--force) # force overwrite of existing chords
      _FORCE=1
      shift
      ;;
    -*|--*=) # unsupported flags
      echo "Error: Unsupported flag $1" >&2
      exit 1
      ;;
    *) # preserve positional arguments
      PARAMS="$PARAMS $1"
      shift
      ;;
  esac
done

# set positional arguments in their proper place
eval set -- "$PARAMS"

dir="$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"

mkdir -p "${HOME}/.local/bin"
cp "${dir}"/bin/ckb-animation "${HOME}/.local/bin/"

mkdir -p "${HOME}/.config/ckb-animation"
cp "${dir}"/config/keys "${HOME}/.config/ckb-animation/keys"
for chord_file in "$dir"/config/chords/*; do
	chord_name="${chord_file##*/}"
  if [ -f "${HOME}/.config/ckb-animation/chords/${chord_name}" ]; then
    if [ -z $_FORCE ]; then
      echo "Found an existing chord file for ${chord_name} – not overwriting. To overwrite, re-run as install.sh -f."
    else
      cp "$chord_file" "${HOME}/.config/ckb-animation/chords/"
    fi
  else
    cp "$chord_file" "${HOME}/.config/ckb-animation/chords/"
  fi
done


sudo cp "${dir}/udev/99-ckb-next-user-animation.rules" "/usr/lib/udev/rules.d/"

mkdir -p "${HOME}/.config/systemd/user/"
cp "${dir}/systemd/ckb-animation.service" "${HOME}/.config/systemd/user/"

if [ -d "~/.bash_completion.d" ]; then
  cp "${dir}/completions/ckb-animation.bash" "${HOME}/.bash_completion.d/"
fi

systemctl --user enable ckb-animation.service
sudo udevadm control --reload-rules && sudo udevadm trigger

