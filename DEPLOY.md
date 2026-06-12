# Deployment cheatsheet

Each of the three standalone projects ships with a static
landing page under `site/` and a `netlify.toml` that
auto-deploys it.  This document is the one-page runbook for
getting all three live on the `*.404piyush.me` subdomains.

## One-time per project (~5 minutes each)

For each of:

- https://github.com/404Piyush/bst-library
- https://github.com/404Piyush/arena-allocator
- https://github.com/404Piyush/pipe-shell

1. **Netlify → New site from Git**
   https://app.netlify.com/start
2. Pick **GitHub** → the repo.
3. Netlify auto-detects `netlify.toml`.  Confirm:
   - Build command: *(empty)*
   - Publish directory: `site`
4. Click **Deploy site**.  You'll get a random
   `*.netlify.app` URL in ~30 seconds.

## Add the custom domain

In Netlify → **Site settings** → **Domain management** →
**Add custom domain** → enter the subdomain:

| Repo | Subdomain |
|---|---|
| bst-library | `bst-library.404piyush.me` |
| arena-allocator | `arena-allocator.404piyush.me` |
| pipe-shell | `pipe-shell.404piyush.me` |

Netlify will print the CNAME target (e.g.
`calm-panda-a1b2c3.netlify.app`).

## DNS records

Go to your DNS provider for `404piyush.me` and add three
CNAMEs:

| Type | Name | Target |
|---|---|---|
| CNAME | bst-library | `<bst-netlify>.netlify.app` |
| CNAME | arena-allocator | `<arena-netlify>.netlify.app` |
| CNAME | pipe-shell | `<pipe-netlify>.netlify.app` |

> If your DNS provider doesn't support CNAME at the
> subdomain level (rare), use an A record pointing to
> Netlify's load balancer IP — they print the right value
> in the Netlify UI.

## Verify

After DNS propagates (5–30 min):

```sh
for sub in bst-library arena-allocator pipe-shell; do
    curl -sI "https://$sub.404piyush.me" | head -1
done
```

All three should return `HTTP/2 200`.

## Continuous deploy

Every push to `main` (or `master`) of each project
redeploys its site automatically — no further action
needed.

## Local preview

```sh
cd <project>/site
python3 -m http.server 8000
# open http://localhost:8000
```

## Per-project details

See `DEPLOY.md` inside each repo for the same instructions
on a per-project basis.
