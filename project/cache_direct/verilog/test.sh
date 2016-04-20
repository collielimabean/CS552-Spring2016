#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "usage: $0 <addr file>"
    exit 1
fi

if [[ ! -e ../verification/$1 ]]; then
    echo "Must be valid file!"
    exit 1
fi

wsrun.pl -addr ../verification/$1 mem_system_perfbench *.v
exit 0
