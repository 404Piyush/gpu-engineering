# day-1-2 — pipes

`pipe(2)` creates a kernel buffer with two file descriptors: a
read end and a write end.  Bytes written to the write end appear
on the read end, in order, until every reference to the write
end is closed.  When that happens, `read(2)` returns 0 — the
"end of file" signal that lets the reader exit its loop.

`pipe(2)` is the building block of shell `|` and of every IPC
channel that does not need a name.  The important things:

1. The pipe capacity on Linux is 64 KiB by default.  When the
   write end is full, `write(2)` either blocks or fails with
   `EAGAIN` (if `O_NONBLOCK` was set).
2. **Every** fd to the write end must be closed in the reader's
   process tree, or `read(2)` will hang forever.
3. The kernel does NOT preserve message boundaries: a 1 KiB write
   can be split across multiple reads, and several small writes
   can be coalesced into one read.

## Programs

| program       | what it shows                                    |
|---------------|--------------------------------------------------|
| `pipe_through` | parent writes, child reads, byte count + xor   |
| `pipe_chain`  | two-child pipeline running `ls | wc -l`         |

## Build

```
make
```

## Run

```
./pipe_through
./pipe_chain
```

## Check it

```
strace -f -e trace=pipe,read,write,close,wait4 ./pipe_chain 2>&1 | head -20
```

You should see one `pipe(...)` call in the parent, then a `clone`
(for `fork`), then a stream of `write(4, ...)` from child 1 and
`read(3, ...)` in child 2.

## Further reading

- `man 2 pipe`
- `man 7 pipe` (the capacity rules)
- *Linux Programming by Example* — Quinn, Ch. 10
- *The Linux Programming Interface* — Kerrisk, Ch. 44
