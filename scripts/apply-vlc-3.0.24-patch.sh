#!/bin/sh
set -eu

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 /absolute/path/to/vlc-3.0.24" >&2
    exit 64
fi

source_dir=$1
if [ ! -f "$source_dir/modules/gui/macosx/VLCFSPanelController.m" ]; then
    echo "Not a VLC 3.0.24 source tree: $source_dir" >&2
    exit 66
fi

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
patch_file=$script_dir/../patches/vlc-3.0.24-fullscreen-trash.patch

cd "$source_dir"
patch --dry-run -p1 < "$patch_file"
patch -p1 < "$patch_file"
