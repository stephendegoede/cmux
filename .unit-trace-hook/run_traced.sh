#!/usr/bin/env bash
# usage: run_traced.sh UNIT_NAME -- commands... ; each line of stdin is one command
set -u
unit="$1"; root="$(git rev-parse --show-toplevel)"
out="$root/.unit-trace/$unit"; mkdir -p "$out"
export UNIT_TRACE_DIR="$out" PYTHONPATH="$root/.unit-trace-hook${PYTHONPATH:+:$PYTHONPATH}"
have_strace=0; command -v strace >/dev/null 2>&1 && have_strace=1
echo "strace=$have_strace" > "$out/meta"
while IFS= read -r cmd; do
  [ -z "$cmd" ] && continue
  echo "== $cmd" >> "$out/meta"
  if [ "$have_strace" = 1 ]; then
    strace -f -qq -e trace=openat,open,getdents64,execve -o "$out/strace.$RANDOM" bash -c "$cmd" > /dev/null 2>&1; echo "exit=$?" >> "$out/meta"
  else
    bash -c "$cmd" > /dev/null 2>&1; echo "exit=$?" >> "$out/meta"
  fi
done
