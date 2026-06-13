#!/bin/sh
# bench/bench_vector_add.sh — bandwidth benchmark for vector_add
#
# Runs the kernel at increasing N, reports effective GB/s.
# A "good" vector-add on a modern GPU should hit
# ~1500-3000 GB/s on the HBM/DDR transfer.
set -eu

BIN=${BIN:-./vector_add}
LOG=${LOG:-../artifacts/bench.log}
mkdir -p "$(dirname "$LOG")"
: > "$LOG"

printf "%-12s %-12s %-8s\n" "N" "elapsed_ms" "GB/s" | tee -a "$LOG"
printf -- "------------ ------------ --------\n" | tee -a "$LOG"

for n in 1048576 4194304 16777216 67108864; do
    out=$("$BIN" "$n" 2>&1)
    elapsed=$(echo "$out" | awk -F'[= ]' '/elapsed/ {print $2}')
    gbs=$(echo "$out" | awk -F'[= ]' '/GB\/s/ {print $2}')
    if [ -z "$elapsed" ]; then
        # Fall back: time the binary
        elapsed=$( { time "$BIN" "$n" >/dev/null; } 2>&1 | awk '/real/{print $2}')
        gbs="?"
    fi
    printf "%-12d %-12s %-8s\n" "$n" "$elapsed" "$gbs" | tee -a "$LOG"
done
