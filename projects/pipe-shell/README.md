# pipe-shell

> **The real project lives at the standalone repo:**
> 👉 **[github.com/404Piyush/pipe-shell](https://github.com/404Piyush/pipe-shell)**
>
> The source code is **not** mirrored in this folder — go to
> the standalone repo for the full build, tests, benchmarks,
> CI, and docs.

## At a glance

- **What it is:** a POSIX-ish command interpreter in C11
- **Curriculum origin:** Week 11 (Month-3 capstone)
- **LOC:** ~500
- **Tests:** 56 assertions, 13 cases — all passing
- **Features:** pipelines, redirection, backgrounding, built-ins
- **License:** MIT

## Quick example

```sh
$ ./pipe-shell --run "ls /etc | grep hosts | wc -l"
       3
$ ./pipe-shell --run "echo hi > /tmp/out.txt; cat /tmp/out.txt"
hi
```

## Get the code

```sh
git clone https://github.com/404Piyush/pipe-shell.git
cd pipe-shell
make test
./pipe-shell
```

---

📚 See the top-level [README](../../README.md#-pipe-shell) and
[PROJECTS.md](../../PROJECTS.md#3-pipe-shell--posix-ish-command-interpreter)
for the full deep-dive.
