#!/bin/sh
cd $(dirname $0)
VC_DIR=$(pwd)
find . -maxdepth 1 -iname ".*" -type f -o -type d -not -name "$(basename .)" -not -name .git | \
    while read path; do
        if [ "X$(basename "$path")" = "X.git" ]; then
            continue
        fi
        destination="$HOME/$path"
        if [ -e "$destination" ]; then
            if [ -L "$destination" ]; then
                echo "Symlink for $path exists, skipping."
                continue
            else
                echo "backing up existing $destination to ${destination}.vc_backup"
                mv "$destination" "${destination}.vc_backup"
            fi
        fi
        echo "doing symlink for $path"
        ln -s "$VC_DIR/$path" "$HOME/$path"
    done
