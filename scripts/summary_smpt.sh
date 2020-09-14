#!/bin/bash
# set -e
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
SMPT_AMT=100000000

if [[ ! -d $1 ]]; then
  echo "$1 is not a directory"
fi

for dir in $(ls "$1"); do
    dir_abs=$(readlink -f "$1/$dir")
    if [[ -d "$dir_abs" ]]; then
        sim_name=$(basename $(readlink -f "$dir_abs"))
        "$SCRIPT_DIR/smpt2ckptdesc.py" "$SMPT_AMT" "$sim_name" "$dir_abs/simpoints" "$dir_abs/weights" 1>/dev/null
    fi
done
