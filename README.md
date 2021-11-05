# ckb-animation

A bash utility to highlight desired keyboard shortcuts when holding different
keyboard shortcut chords. Built for [ckb-next](https://github.com/ckb-next/ckb-next),

Requires that the keyboard currently be utilizing the `pipe000` animation. Designed
around a K70 non RGB, so keys are strictly on/off at full brightness. If this was
an RGB model, all 3 channels are set to full, so the color would be white.

# Usage

```
usage: ckb-animation [-h | --help] <command> [<args>]

Managing the animation daemon:
  start                             start the animation
  restart                           restart the animation
  stop                              stop the animation
  status                            see the status of the animation

Configuring the keys for the animation:

  add <chord> <key>...              add keys to the given chord
  remove <chord> <key>...           remove keys from the given chord
  view {chord|keys|all} [<chord>]   view the keys for the given chord, all the chrods, key names

Accepted chords are the following

Single keys:
  ALT: {alt|Alt}
  SHIFT: {shift|Shift}
  CTRL: {ctrl|Ctrl|control|Control}
  SUPER: {meta|Meta|super|Super|win|Win|windows|Windows}

Multiple key chords are the following combinations of the single key options seperated by a '-':
  CTRL-ALT
  CTRL-SHIFT
  SUPER-ALT
  SUPER-CTRL
  SUPER-SHIFT
  CTRL-ALT-SHIFT
```
