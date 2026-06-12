# Deployment

Each of the three standalone projects ships with a static
landing page under `site/` and a `netlify.toml` that
auto-deploys it. The three sites are already deployed to
Netlify and have their custom domains set. This document
is the one-page runbook if you ever need to redeploy from
scratch or add a new project.

## Netlify state

| Project | Netlify URL | Custom domain |
|---|---|---|
| bst-library | https://bst-library.netlify.app | bst-library.404piyush.me |
| arena-allocator | https://arena-allocator.netlify.app | arena-allocator.404piyush.me |
| pipe-shell | https://pipe-shell.netlify.app | pipe-shell.404piyush.me |

Each Netlify site is linked to the corresponding GitHub
repo. Every push to `main` redeploys automatically.

## Redeploy from scratch

For each of the three repos:

1. Go to https://app.netlify.com/start and click
   **Import an existing project**.
2. Pick **GitHub** and the repo.
3. Netlify will detect `netlify.toml`. Confirm:
   - Build command: empty
   - Publish directory: `site`
4. Click **Deploy site**. You will get a random
   `*.netlify.app` URL in about 30 seconds.

## Add the custom domain

In Netlify, go to **Site settings** then
**Domain management** then **Add custom domain**, and
enter:

- `bst-library.404piyush.me`
- `arena-allocator.404piyush.me`
- `pipe-shell.404piyush.me`

## Local preview

```sh
cd <project>/site
python3 -m http.server 8000
# open http://localhost:8000
```

## Per-project details

Each standalone repo has its own `DEPLOY.md` with the same
instructions scoped to that project.

For DNS, see [DNS.md](DNS.md).
