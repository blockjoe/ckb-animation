#!/bin/bash

systemclt --user stop ckb-animation.service
systemctl --user disable ckb-animation.service

sudo rm /usr/lib/udev/rules.d/99-ckb-next-user-animation.rules

rm "${HOME}/.local/bin/ckb-animation"
rm -rf "${HOME}/.config/ckb-animation"

if [ -f "${HOME}/.bash_completion.d/ckb-animation.bash" ]; then
  rm "${HOME}/.bash_completion.d/ckb-animation.bash"
fi
