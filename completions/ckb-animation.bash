#!/usr/bin/env bash

key_opts="mr m1 m2 m3 light lock mute volup voldn g1 g2 g3 esc f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 prtscn scroll pause stop prev play next g4 g5 g6 grave 1 2 3 4 5 6 7 8 9 0 minus equal yen bspace ins home pgup numlock numslash numstar numminus g7 g8 g9 tab q w e r t y u i o p lbrace rbrace bslash enter del end pgdn num7 num8 num9 numplus g10 g11 g12 caps a s d f g h j k l colon quote hash num4 num5 num6 g13 g14 g15 lshift bslash_iso z x c v b n m comma dot slash ro rshift up num1 num2 num3 numenter g16 g17 g18 lctrl lwin lalt muhenkan space henkan katahira ralt rwin rmenu rctrl left down right num0 numdot"

chord_opts="alt Alt shift Shift ctrl Ctrl control Control meta Meta super Super win Win Windows windows ctrl-alt ctrl-Alt Ctrl-alt Ctrl-Alt control-alt control-Alt Control-alt Control-Alt alt-ctrl alt-Ctrl alt-control alt-Control Alt-ctrl Alt-Ctrl Alt-control Alt-Control ctrl-shift ctrl-Shift Ctrl-shift Ctrl-Shift control-shift control-Shift Control-shift Control-Shift shift-ctrl shift-Ctrl shift-control shift-Control Shift-ctrl Shift-Ctrl Shift-control Shift-Control alt-meta alt-Meta alt-super alt-Super alt-win alt-Win alt-Windows alt-windows Alt-meta Alt-Meta Alt-super Alt-Super Alt-win Alt-Win Alt-Windows Alt-windows meta-alt meta-Alt Meta-alt Meta-Alt super-alt super-Alt Super-alt Super-Alt win-alt win-Alt Win-alt Win-Alt Windows-alt Windows-Alt windows-alt windows-Alt ctrl-meta ctrl-Meta ctrl-super ctrl-Super ctrl-win ctrl-Win ctrl-Windows ctrl-windows Ctrl-meta Ctrl-Meta Ctrl-super Ctrl-Super Ctrl-win Ctrl-Win Ctrl-Windows Ctrl-windows control-meta control-Meta control-super control-Super control-win control-Win control-Windows control-windows Control-meta Control-Meta Control-super Control-Super Control-win Control-Win Control-Windows Control-windows meta-ctrl meta-Ctrl meta-control meta-Control Meta-ctrl Meta-Ctrl Meta-control Meta-Control super-ctrl super-Ctrl super-control super-Control Super-ctrl Super-Ctrl Super-control Super-Control win-ctrl win-Ctrl win-control win-Control Win-ctrl Win-Ctrl Win-control Win-Control Windows-ctrl Windows-Ctrl Windows-control Windows-Control windows-ctrl windows-Ctrl windows-control windows-Control shift-meta shift-Meta shift-super shift-Super shift-win shift-Win shift-Windows shift-windows Shift-meta Shift-Meta Shift-super Shift-Super Shift-win Shift-Win Shift-Windows Shift-windows meta-shift meta-Shift Meta-shift Meta-Shift super-shift super-Shift Super-shift Super-Shift win-shift win-Shift Win-shift Win-Shift Windows-shift Windows-Shift windows-shift windows-Shift shift-alt-ctrl shift-alt-Ctrl shift-alt-control shift-alt-Control shift-Alt-ctrl shift-Alt-Ctrl shift-Alt-control shift-Alt-Control Shift-alt-ctrl Shift-alt-Ctrl Shift-alt-control Shift-alt-Control Shift-Alt-ctrl Shift-Alt-Ctrl Shift-Alt-control Shift-Alt-Control shift-ctrl-alt shift-ctrl-Alt shift-Ctrl-alt shift-Ctrl-Alt shift-control-alt shift-control-Alt shift-Control-alt shift-Control-Alt Shift-ctrl-alt Shift-ctrl-Alt Shift-Ctrl-alt Shift-Ctrl-Alt Shift-control-alt Shift-control-Alt Shift-Control-alt Shift-Control-Alt alt-shift-ctrl alt-shift-Ctrl alt-shift-control alt-shift-Control alt-Shift-ctrl alt-Shift-Ctrl alt-Shift-control alt-Shift-Control Alt-shift-ctrl Alt-shift-Ctrl Alt-shift-control Alt-shift-Control Alt-Shift-ctrl Alt-Shift-Ctrl Alt-Shift-control Alt-Shift-Control alt-ctrl-shift alt-ctrl-Shift alt-Ctrl-shift alt-Ctrl-Shift alt-control-shift alt-control-Shift alt-Control-shift alt-Control-Shift Alt-ctrl-shift Alt-ctrl-Shift Alt-Ctrl-shift Alt-Ctrl-Shift Alt-control-shift Alt-control-Shift Alt-Control-shift Alt-Control-Shift ctrl-shift-alt ctrl-shift-Alt ctrl-Shift-alt ctrl-Shift-Alt Ctrl-shift-alt Ctrl-shift-Alt Ctrl-Shift-alt Ctrl-Shift-Alt control-shift-alt control-shift-Alt control-Shift-alt control-Shift-Alt Control-shift-alt Control-shift-Alt Control-Shift-alt Control-Shift-Alt ctrl-alt-shift ctrl-alt-Shift ctrl-Alt-shift ctrl-Alt-Shift Ctrl-alt-shift Ctrl-alt-Shift Ctrl-Alt-shift Ctrl-Alt-Shift control-alt-shift control-alt-Shift control-Alt-shift control-Alt-Shift Control-alt-shift Control-alt-Shift Control-Alt-shift Control-Alt-Shift"

key_dir="${HOME}/.config/ckb-animation/chords"

get_chord_file() {
	while IFS='-' read -ra chord; do
		for i in "${chord[@]}"; do
			case "$i" in
				alt|Alt)
					has_alt=1
					;;
				ctrl|Ctrl|control|Control)
					has_ctrl=1
					;;
				shift|Shift)
					has_shift=1
					;;
				meta|Meta|super|Super|win|Win|windows|Windows)
					has_meta=1
					;;
				*)
					has_error=1
					;;
			esac
		done
	done <<< "$1"
	if [ -n "$has_error" ]; then
		echo "Unsupported chord: ${1}"
	elif [ -n "$has_ctrl" -a -n "$has_shift" -a -n "$has_alt" ]; then
		echo "${key_dir}/ctrl_alt_shift"
	elif [ -n "$has_ctrl" -a -n "$has_alt" ]; then
		echo "${key_dir}/ctrl_alt"
	elif [ -n "$has_ctrl" -a -n "$has_shift" ]; then
		echo "${key_dir}/ctrl_shift"
	elif [ -n "$has_shift" -a -n "$has_alt" ]; then
		echo "${key_dir}/alt_shift"
	elif [ -n "$has_meta" -a -n "$has_alt" ]; then
		echo "${key_dir}/meta_alt"
	elif [ -n "$has_meta" -a -n "$has_shift" ]; then
		echo "${key_dir}/meta_shift"
	elif [ -n "$has_meta" -a -n "$has_ctrl" ]; then
		echo "${key_dir}/meta_ctrl"
	elif [ -n "$has_ctrl" ]; then
		echo "${key_dir}/ctrl"
	elif [ -n "$has_alt" ]; then
		echo "${key_dir}/alt"
	elif [ -n "$has_meta" ]; then
		echo "${key_dir}/meta"
	elif [ -n "$has_shift" ]; then
		echo "${key_dir}/shift_"
	else
		echo "Unsupported, invalid, or empty chord ${1}"
	fi
}

_ckb_animation_completions()
{
  local cur cmd arg

  COMPREPLY=()
  if [ $COMP_CWORD -eq 1 ]; then
    cur=${COMP_WORDS[1]}
		COMPREPLY=( $(compgen -W "start restart stop status add view remove" -- $cur) )
  elif [ $COMP_CWORD -gt 1  ]; then
    cur=${COMP_WORDS[$COMP_CWORD]}
    cmd=${COMP_WORDS[1]}
    case "$cmd" in
      add)
        if [ $COMP_CWORD -eq 2 ]; then
					COMPREPLY=( $(compgen -W "$chord_opts" -- $cur) )
				else
					COMPRELPY=( $(compgen -W "$key_opts" -- $cur) )
				fi
        ;;
      remove)
        if [ $COMP_CWORD -eq 2 ]; then
					COMPREPLY=( $(compgen -W "$chord_opts" -- $cur) )
				else
					arg=${COMP_WORDS[2]}
					chord_file="$(get_chord_file "$arg")"
					if [ -f "$chord_file" ]; then
						keys=$(tr '\n' ' ' < "$chord_file")
						COMPREPLY=( $(compgen -W "$keys" -- $cur) )
					fi
        fi
        ;;
      view)
        if [ $COMP_CWORD -eq 2 ]; then
					COMPREPLY=( $(compgen -W "chord keys all" -- $cur) )
				elif [ $COMP_CWORD -eq 3 ]; then
					arg=${COMP_WORDS[2]}
					if [ $arg == "chord" ]; then
						COMPREPLY=( $(compgen -W "$chord_opts" -- $cur) )
					fi
				fi
        ;;
    esac
  fi
}
command -v foo >/dev/null 2>&1 && complete -F _ckb_animation_completions ckb-animation
