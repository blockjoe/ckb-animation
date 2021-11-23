from itertools import permutations, product, starmap

alt = ("alt", "Alt")
shift = ("shift", "Shift")
ctrl = ("ctrl", "Ctrl", "control", "Control" )
meta = ("meta", "Meta", "super", "Super", "win", "Win", "Windows", "windows" )

chords_2 = ( (ctrl, alt), (ctrl, shift), (alt, meta), (ctrl, meta), (shift, meta) )
chords_3 = ( (shift, alt, ctrl), )

opts = []
opts.extend(alt)
opts.extend(shift)
opts.extend(ctrl)
opts.extend(meta)

for key1, key2 in chords_2:
    for perm in permutations((key1, key2), 2):
        for prod in product(*perm):
            opts.append("-".join(item for item in prod))

for key1, key2, key3 in chords_3:
    for perm in permutations((key1, key2, key3), 3):
        for prod in product(*perm):
            opts.append("-".join(item for item in prod))

print('chord_opts="{}"'.format(" ".join(opts)))


