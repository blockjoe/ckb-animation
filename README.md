# ckb-animation

A bash utility to highlight desired available shortcuts when holding different
keyboard shortcut chords. Built for [ckb-next](https://github.com/ckb-next/ckb-next)'s,
pipe animations.

## Quirks

`ckb-animation` was built specifically for my own personal setup. I've tried to keep
things generalized, but some of these choices might get in the way of other configurations.
The major quirks/impacts of my current setup are:

- The LEDs turn to either full red (full white on RGB) or completely off.
- `ckb-next` is configured to have only one mode and one animation, – `pipe000` (does not play nice with many modes/animations).
- I'm using `bash` (works with other shells, just no completions) and `systemd` (would need to be modified for other init systems).
- I use the following chords: `ctrl`, `alt`, `super`, `ctrl-alt`, `ctrl-shift`, `ctrl-super`, `alt-super`, `alt-shift`, `super-shift`, and `ctrl-alt-shift`.

If these are problems, check out the [Hacking](#hacking) to see where things would need to be modified to change this behavior to better fit your needs.

## Installation

### `ckb-next` 

If you don't have `ckb-next` installed, [install it](https://github.com/ckb-next/ckb-next/wiki/Linux-Installation).

Launch the `ckb-next` GUI.

To configure the animation, select the tab that represents the model of your keyboard and

1. On the default profile, click the "New animation..." button.
2. For "Animation:" select "Pipe" and press OK.
3. Make sure that "/tmp/ckbpipe" is set to 0, and "Start with mode" is checked and press OK.

To make sure that `ckb-next` is launched on login, make sure "Settings > Application > Start ckb-next at login" 
is checked. 

### `ckb-animation`

To install `ckb-animation` simply run the following, and
enter your `sudo` password when prompted.

```sh
git clone https://github.com/blockjoe/ckb-animation.git
cd ckb-animation
./install.sh
```

The main `ckb-animation` script will be installed to 
`~/.local/bin`. If this isn't in `PATH`, add the 
following line to your `~/.bashrc`.

```sh
export PATH=$PATH:$HOME/.local/bin
```

The install script needs root permissions to install the 
`udev` rule for tagging the keyboard so `systemd` can see it.

A `systemd` user service will be enabled named `ckb-animation.service`
so the service will be automatically started on login.

If the user had a `~/.bash_completion.d` directory defined, the
bash completions will be automatically installed there. If not, see
the section about [completions](#completions) for manually configuring them


## Usage

Check to see if `ckb-animation` is running.

```sh
$ ckb-animation status
```

If it is not running start it.

```sh
$ ckb-animation start
```

See the current key configurations for all chords

```sh
$ ckb-animation view all
```

Add the all number keys to the "Control + Alt" chord. 

```sh
$ ckb-animation add ctrl-alt 1 2 3 4 5 6 7 8 9 0
```

Remove h,j,k, and l from the "Alt" chord.

```sh
$ ckb-animation remove alt h j k l
```

View the help message

```sh
$ ckb-animation --help

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


## Hacking

### Colors

Setting an LED to a specific color follows the given format
`<key>:<red><greeb><blue><alpha>`. Further details can be found
through [ckb-next](https://github.com/ckb-next/ckb-next/wiki/Animations#pipe).

```sh
echo "rbg space:ff000088" > /tmp/ckbpipe000 # Space red at 50% opacity.
echo "rgb 1:ffffffff" > /tmp/ckbpipe000 # 1 white at 100% opacity.
echo "rgb 000000ff" > /tmp/ckbpipe000 # all keys black at 100% opacity.
```

The script `bin/ckb-animation` simply defines two helper functions `key_on`, `key_off`.
They refer to variables `$on` and `$off` respectively. If you had an RGB keyboard,
and wanted the baseline keys to be blue, and the highlighted keys be green, the following
lines in `bin/ckb-animation` should change from

```sh
on="ffffffff"
off="000000ff"
```

to 

```sh
on="0000ffff"
off="00ff00ff"
```

### Multiple modes

The only thing limiting us to the single pipe animation is the choice to write all events to
`/tmp/ckbpipe000`. We define this in the `bin/ckb-animation` script with `ckb=/tmp/ckbpipe000`,
and then force it to apply to all keys by piping to `$ckb` in `key_on`, `key_off`, `keyboard_on`,
and `keyboard_off`. If we were to create different mode configurations and find a way to tell
the current mode that we're in, we could choose to conditionally pipe to whichever pipe we want.


### Adding/Removing chords

For example, let's add `ctrl-super-shift` as an available chord.

#### `bin/ckb-animation`

Let's first add the mode in `bin/ckb-animation`

In `main()`, make change the following line:

```bash
elif [[ $ctrl_down == $true && $super_down == $true && $shift_down == $true ]]; then
  mode="ctrl_super_shift" # mode="default"
```

Then in `get_chord_file()` add the following lines:

```bash
elif [ -n "$has_ctrl" -a -n "$has_shift" -a -n "$has_alt" ]; then
  echo "ctrl_alt_shift"
elif [ -n "$has_ctrl" -a -n "$has_shift" -a -n "$has_super" ]; then # Add this
  echo "ctrl_super_shift" # Add this
elif [ -n "$has_ctrl" -a -n "$has_alt" ]; then
  echo "ctrl_alt"
```


Make sure to update the `usage()` message.:

```bash
  echo "  SUPER-SHIFT"
  echo "  CTRL-ALT-SHIFT"
  echo "  CTRL-SUPER-SHIFT" # Add this
```

Then make an empty file under `config/chords` named `config/chords/ctrl_super_shift`

```sh
touch config/chords/ctrl_super_shift
```

To add h, j, k, and l as the first keys, run:

```sh
bin/ckb-animation add ctrl-super-shift h j k l
```

#### `completions/ckb-animation.bash`

To include this new chord in the completions, in `completions/ckb-animation.bash`, update
the `get_chord_file()` function to match how it was defined in `bin/ckb-animation`, i.e.

```bash
elif [ -n "$has_ctrl" -a -n "$has_shift" -a -n "$has_alt" ]; then
  echo "ctrl_alt_shift"
elif [ -n "$has_ctrl" -a -n "$has_shift" -a -n "$has_super" ]; then # Add this
  echo "ctrl_super_shift" # Add this
elif [ -n "$has_ctrl" -a -n "$has_alt" ]; then
  echo "ctrl_alt"
```

From there, we simply need to update `chord_opts` to properly reflect that we now
can support a "Control + Super + Shift" combination. 

Instead of manually specifying this, head on over to `helpers/supported-combos.py`, and
change

```python
chords_3 = (( (shift, alt, ctrl), (shift, meta, ctrl) ) # chords_3 = ((shift, alt, ctrl), )
```

and run it to get the new `chords_opts=...` line for `completions/ckb-animation.bash`

```sh
python helpers/supported-combos.py
```

Finally, all of these changes can be installed by running:
```sh
./install.sh
```

### Completions

#### bash

To manually install bash completions:

Make a `~/.bash_completion.d` directory and copy the completion file to it.

```sh
mkdir ~/.bash_completion.d/
cp completions/ckb-animation.bash ~/.bash_complettion.d/
```

Make a `~/.bash_completion` file that contains the following:

```bash
for bcfile in ~/.bash_completion.d/*; do
  [ -f "$bcfile" ] && . "$bcfile"
done
```

Then add the following into your `~/.bashrc`:

```bash
if [ -f ~/.bash_completion ]; then
  . ~/.bash_completion
fi
```


#### zsh

A cursory search shows that the `bash` completions should be compatible with `zsh`. 

I assume the following should work, but have not tested it.

```sh
mkdir ~/.bash_completion.d/
cp completions/ckb-animation.bash ~/.bash_complettion.d/
```

Make a `~/.bash_completion` file that contains the following:

```bash
for bcfile in ~/.bash_completion.d/*; do
  [ -f "$bcfile" ] && . "$bcfile"
done
```

Then add the following to your `.zshrc`

```zsh
autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit
source ~/.bash_completion
```

