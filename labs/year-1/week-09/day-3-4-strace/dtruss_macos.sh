#!/usr/bin/env bash
# day-3-4-strace/dtruss_macos.sh
#
# macOS equivalent of Linux strace.  `dtruss` is a DTrace consumer
# that shows syscall entries/exits. Requires root because it uses
# the kernel's trace facility.
#
# Usage:
#   sudo ./dtruss_macos.sh
#   (uses ./trace_target by default)
#
# If you don't have dtruss (it ships with Xcode Command Line Tools
# under /usr/bin/dtruss), the script falls back to `fs_usage` which
# is also root-required but less noisy.
set -euo pipefail

PROG=${PROG:-./trace_target}

if [[ $EUID -ne 0 ]]; then
    echo "dtruss needs root. Re-run with:  sudo $0" >&2
    exit 1
fi

if command -v dtruss >/dev/null 2>&1; then
    echo "=== sudo dtruss -f $PROG ==="
    dtruss -f "$PROG" /etc/hosts 2>&1 | head -40
elif command -v fs_usage >/dev/null 2>&1; then
    echo "=== sudo fs_usage -w -f filesys $PROG ==="
    timeout 5 fs_usage -w -f filesys "$PROG" /etc/hosts 2>&1 | head -40
else
    echo "No syscall tracer available. Install Xcode CLT for dtruss." >&2
    exit 1
fi
