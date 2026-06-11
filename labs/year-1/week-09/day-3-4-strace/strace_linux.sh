#!/usr/bin/env bash
# day-3-4-strace/strace_linux.sh
#
# Linux equivalent of macOS dtruss. `strace` shows every syscall
# a process makes. Useful for understanding the userland→kernel
# boundary. Requires `strace` (apt: `apt install strace`).
set -euo pipefail

if ! command -v strace >/dev/null 2>&1; then
    echo "strace not installed. On Debian/Ubuntu: apt install strace" >&2
    exit 1
fi

PROG=${PROG:-./trace_target}
echo "=== strace -f -e trace=open,read,close $PROG ==="
strace -f -e trace=openat,read,close,exit_group -- \
    "$PROG" /etc/hosts
