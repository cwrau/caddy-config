#!/bin/bash

reloadNecessary=0
configDir="$1"
outDir="$2"

for name in $(cat "$configDir/properties")
do
    config=$(sed -r "s#@name@#$name#g" "$configDir/template")
    diff -N "$outDir/$name.conf" <(echo "$config")
    reloadNecessary=$(( $reloadNecessary + $?))
    echo "$config" > "$outDir/$name.conf"
done

exit $reloadNecessary
