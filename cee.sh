#!/bin/bash

DEFAULT_COMPILER="gcc"
DEFAULT_FLAGS="-Wall -Wpedantic -O2"

if [[ $# == 0 ]]; then
    echo "Usage: cee <options>"
    echo -e "\nOptions:"
    echo "  [build, b]: build the project without running"
    echo "  [run, r]: build & run the project"
    echo "  [new, n] <name>: create a new project"
    echo "  [init, i]: init project in pwd"
    exit 0
fi

if [[ $1 == "new" || $1 == "n" ]]; then
    [[ $# == 1 ]] && { echo "No project name specified!"; exit 0; }
    
    [[ -d "$2" || -f "$2" ]] && { echo "$2: Path already exists"; exit 0; }

    mkdir "$2" "$2/src" "$2/bin"
    echo -e "#include <stdio.h>\n\nint main() {\n    printf(\"Hello, World!\\\\n\");\n    return 0;\n}\n" > "$2/src/main.c"
    echo -e "## cee configuration file\n## format follows a strict \"key: value\" layout\ncompiler: $DEFAULT_COMPILER\nflags: $DEFAULT_FLAGS" > "$2/cee.conf"

elif [[ $1 == "init" || $1 == "i" ]]; then
    mkdir src bin || { echo "./src or ./bin already exists!"; exit 1; }

    echo -e "#include <stdio.h>\n\nint main() {\n    printf(\"Hello, World!\\\\n\");\n    return 0;\n}\n" > src/main.c
    echo -e "## cee configuration file\n## format follows a strict \"key: value\" layout\ncompiler: $DEFAULT_COMPILER\nflags: $DEFAULT_FLAGS" > cee.conf

elif [[ $1 == "build" || $1 == "b" || $1 == "run" || $1 == "r" ]]; then
    COMPILER=$(grep -oP '(?<=compiler: ).*' cee.conf)
    FLAGS=$(grep -oP '(?<=flags: ).*' cee.conf)
    
    echo $FLAGS | xargs $COMPILER src/main.c -o bin/main

    [[ $1 == "run" || $1 == "r" ]] && ./bin/main
fi
