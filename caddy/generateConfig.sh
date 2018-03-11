#!/bin/bash

reloadNecessary=0

mkdir -p /caddy/conf.d/generated.d

for f in generators.d/*.sh
do
    configDir="/caddy/generators.d/$(basename "${f%.sh}").d"
    outDir="/caddy/conf.d/generated.d"
    ./"$f" "$configDir" "$outDir"
    reloadNecessary=$(( $reloadNecessary + $? ))
done


if [[ $reloadNecessary != 0 ]]
then
    pkill -USR1 caddy
fi
