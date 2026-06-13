#!/bin/sh
# bench/run_bench.sh — baseline benchmark for the existing projects
#
# Measures wall clock, CPU time, peak RSS, and (where possible)
# syscall counts for the existing arena-allocator and pipe-shell
# binaries.  Run on macOS arm64 (this machine) and Linux x86_64
# (the CI runners).
#
# Usage:  bench/run_bench.sh
# Output: stdout (one row per scenario) + artifacts/*.txt
set -eu

ROOT=$(cd "$(dirname "$0")/.." && pwd)
OUT="$ROOT/artifacts"
mkdir -p "$OUT"

# Allow the caller to point at any pre-built arena-allocator or
# pipe-shell.  Defaults assume the standalone repos are cloned
# at /tmp/ (where this build session keeps them).
ARENA_REPO=${ARENA_REPO:-"/tmp/arena-allocator"}
SHELL_REPO=${SHELL_REPO:-"/tmp/pipe-shell"}

ARENA_BIN=${ARENA_BIN:-"$ARENA_REPO/build/bench_arena"}
SHELL_BIN=${SHELL_BIN:-"$SHELL_REPO/pipe-shell"}

if [ ! -x "$ARENA_BIN" ]; then
    echo "Building arena-allocator bench..."
    (cd "$ARENA_REPO" && make bench N=1000000 >/dev/null)
    ARENA_BIN="$ARENA_REPO/build/bench_arena"
fi
if [ ! -x "$SHELL_BIN" ]; then
    echo "Building pipe-shell..."
    (cd "$SHELL_REPO" && make >/dev/null)
    SHELL_BIN="$SHELL_REPO/pipe-shell"
fi

LOG="$OUT/bench.log"
: > "$LOG"

run() {
    name=$1; shift
    echo "=== $name ===" | tee -a "$LOG"
    printf "  command: %s\n" "$*" >> "$LOG"

    # Use /usr/bin/time -l (macOS) for wall clock, CPU, peak RSS.
    # We capture both stdout (the bench output) and the time
    # output to stderr.
    if /usr/bin/time -l "$@" > "$OUT/$name.out" 2> "$OUT/$name.time"; then
        :
    fi

    # Extract the numbers we care about from the time output.
    wall=$(awk '/real/{print $1; exit}' "$OUT/$name.time" 2>/dev/null || true)
    user=$(awk '/user/{print $1; exit}' "$OUT/$name.time" 2>/dev/null || true)
    sys=$(awk '/sys/{print $1; exit}' "$OUT/$name.time" 2>/dev/null || true)
    rss=$(grep -E 'maximum resident set size' "$OUT/$name.time" 2>/dev/null \
          | awk '{print $1}' || echo "?")
    printf "%-30s wall=%-8s user=%-8s sys=%-8s rss=%s\n" \
           "$name" "${wall:-?}" "${user:-?}" "${sys:-?}" "${rss:-?}" | tee -a "$LOG"
}

echo "Host: $(uname -srvmo)" | tee -a "$LOG"
echo "Date: $(date)" | tee -a "$LOG"
echo

# 1. arena-allocator: pure alloc pressure
run "arena_alloc_1M"           "$ARENA_BIN" 1000000

# 2. arena-allocator: phase pattern (alloc + reset cycle)
run "arena_cycle_1k_x_1k"       "$ARENA_BIN" 1000000

# 3. arena-allocator: long run (N=5M) to amortise
run "arena_alloc_5M"           "$ARENA_BIN" 5000000

# 4. pipe-shell: small pipeline
run "pipe_ls_grep_wc"          "$SHELL_BIN" --run "ls /tmp | grep Mini | wc -l"

# 5. pipe-shell: 4-stage pipeline
run "pipe_4stage"              "$SHELL_BIN" --run "cat /etc/hosts | awk '{print \$1}' | head -1 | wc -c"

# 6. pipe-shell: built-in (no fork)
run "pipe_builtin_cd"           "$SHELL_BIN" --run "cd /tmp && pwd"

# 7. pipe-shell: large pipeline throughput (N=1000)
echo
echo "=== pipe_1000_pipelines ===" | tee -a "$LOG"
START=$(date +%s)
for i in $(seq 1 1000); do
    "$SHELL_BIN" --run "true" >/dev/null
done
END=$(date +%s)
ELAPSED=$((END - START))
printf "pipe_1000_pipelines  %d pipelines in %ds  -> %d pipelines/s\n" \
       1000 "$ELAPSED" "$((1000 / ELAPSED))" | tee -a "$LOG"

echo
echo "Wrote bench output to $LOG"
echo "Per-scenario output:  $OUT/<scenario>.out"
echo "Time output:          $OUT/<scenario>.time"
