#!/bin/bash

# this is because '_' sorts differently with different locales
LC_COLLATE=C

# To produce null strings when no match
shopt -s nullglob
# To enable !(nothis)
shopt -s extglob

# To init the file (anew)
sha512sum ../grade.sh >hashes.txt

arr=(
    !(*hashes.txt)
    ../.gitlab-ci.yml
    ../Cargo.toml
    ../cfg_tests/goals/*
    ../cfg_tests/goal_cfgs/*
    ../stdio_tests/goals/*
    ../stdio_tests/inputs/*
    ../arg_tests/args/*
    ../arg_tests/goals/*
    ../arg_tests/files/*
    ../unit_tests/*
    ../mem_tests/*
)

for file_to_hash in "${arr[@]}"; do
    if [ -f "$file_to_hash" ]; then
        sha512sum "$file_to_hash" >>hashes.txt
    fi
done

shopt -u nullglob
shopt -u extglob
