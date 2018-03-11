#!/bin/bash

reloadNecessary=0
configDir="$1"
outDir="$2"

for p in $(cat "$configDir/properties")
do
    name=${p%=*}
    port=${p#*=}
    config=$(sed -r "s#@name@#$name#g; s#@port@#$port#g" "$configDir/template")
    diff -N "$outDir/$name.conf" <(echo "$config")
    reloadNecessary=$(( $reloadNecessary + $?))
    echo "$config" > "$outDir/$name.conf"
done

exit $reloadNecessary
