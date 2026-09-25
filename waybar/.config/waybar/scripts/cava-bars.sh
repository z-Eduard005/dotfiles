#! /bin/bash

bar="▁▂▃▄▅▆▇█"
dict="s/;//g;"

# creating "dictionary" to replace char with bar
i=0
while [ $i -lt ${#bar} ]
do
    dict="${dict}s/$i/${bar:$i:1}/g;"
    i=$((i=i+1))
done

# write cava config
config_file="/tmp/polybar_cava_config"
echo "
[general]
bars = 18

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7
" > $config_file

# read stdout from cava; empty output on silence (module hides), exit if cava dies
cava -p $config_file | while true; do
    if IFS= read -t 1 -r line; then
        out=$(echo $line | sed $dict)
        case "$out" in *[!▁]*) printf '%s\n' "$out" ;; *) printf '\n' ;; esac
    else
        [ $? -gt 128 ] && printf '\n' && continue
        break
    fi
done