#!/bin/sh
# profile/sample.sh — capture top hotspots with macOS `sample`
#
# Uses Apple's `sample` (preinstalled on macOS) to do
# statistical sampling of the running process.  Output is a
# call-graph-style text file with hot functions.
#
# Usage:  profile/sample.sh <scenario>
# Output: profile/<scenario>.sample.txt
set -eu

ROOT=$(cd "$(dirname "$0")/.." && pwd)
OUT="$ROOT/profile"
mkdir -p "$OUT"

scenario=${1:-arena_alloc_1M}

ARENA_BIN=${ARENA_BIN:-/tmp/arena-allocator/build/bench_arena}
SHELL_BIN=${SHELL_BIN:-/tmp/pipe-shell/pipe-shell}

# Default workloads: run long enough that `sample` (which
# needs the process alive for ~5-10s) gets useful data.
case "$scenario" in
    arena_*)
        TARGET="$ARENA_BIN"
        ARGS=${ARGS:-5000000}
        ;;
    pipe_*)
        TARGET="$SHELL_BIN"
        case "$scenario" in
            pipe_*pipeline*|pipe_1000*)
                # Run a tight loop so the shell is hot for the
                # full sampling window.
                (
                    for i in $(seq 1 5000); do
                        "$SHELL_BIN" --run "true" >/dev/null
                    done
                ) &
                LOOP_PID=$!
                sleep 0.2
                SAMPLE_PID=$LOOP_PID
                ;;
            *)
                ARGS=${ARGS:---run "ls /tmp | grep Mini | wc -l"}
                ;;
        esac
        ;;
    *)
        echo "Unknown scenario: $scenario" >&2
        echo "Known: arena_*, pipe_*" >&2
        exit 1
        ;;
esac

OUTFILE="$OUT/${scenario}.sample.txt"
echo "Sampling $scenario -> $OUTFILE"
if [ "${pipe_1000:-no}" = "yes" ] || [ "$scenario" = "pipe_1000_pipelines" ]; then
    sample $SAMPLE_PID 5 -mayDie 2>/dev/null > "$OUTFILE" || true
    kill $LOOP_PID 2>/dev/null || true
    wait $LOOP_PID 2>/dev/null || true
else
    (
        "$TARGET" ${ARGS:-1000000} >/dev/null 2>&1 &
        PID=$!
        sleep 0.2
        sample $PID 5 -mayDie > "$OUTFILE" 2>/dev/null || true
        wait $PID 2>/dev/null || true
    )
fi

if [ -s "$OUTFILE" ]; then
    echo "  $(wc -l < "$OUTFILE") lines of profiling data captured"
    # Show the top 15 hot functions
    echo
    echo "  Top 15 symbols (filtered):"
    grep -E '^\s+[0-9]+\s' "$OUTFILE" | head -15 | sed 's/^/    /'
else
    echo "  (no data captured)"
fi
