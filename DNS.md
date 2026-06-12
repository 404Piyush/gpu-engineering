# DNS setup for the three subdomains

The 3 Netlify sites are deployed and the custom-domain
fields are set on Netlify's side.  The sites will not
actually serve on `*.404piyush.me` until you add CNAME
records to your DNS provider for `404piyush.me`.

## The three CNAMEs to add

Go to wherever `404piyush.me` is managed (Cloudflare,
Namecheap, Route53, etc.) and add:

| Type | Name | Target | TTL |
|---|---|---|---|
| CNAME | `bst-library` | `bst-library.netlify.app` | 300 |
| CNAME | `arena-allocator` | `arena-allocator.netlify.app` | 300 |
| CNAME | `pipe-shell` | `pipe-shell.netlify.app` | 300 |

> Some DNS providers call the `Name` field "Host" or
> "Subdomain".  If your provider doesn't support CNAME on
> subdomains (very rare), use an ALIAS or ANAME record
> pointing to the same target.

## Verify

After 5–30 minutes for DNS propagation:

```sh
for sub in bst-library arena-allocator pipe-shell; do
    echo "=== $sub.404piyush.me ==="
    dig +short "$sub.404piyush.me" CNAME
    curl -sI "https://$sub.404piyush.me" | head -3
done
```

You should see:

- The CNAME record points to `<sub>.netlify.app`
- HTTPS returns `HTTP/2 200` with a `Strict-Transport-Security`
  header (proves Let's Encrypt cert was auto-provisioned)

## What happens on Netlify's side

Once the CNAMEs are in place and Netlify detects them:

- Netlify auto-provisions a Let's Encrypt TLS certificate
  (DNS-01 challenge, takes ~2 min).
- HTTPS on the custom domain is live ~5 min after DNS.
- The original `*.netlify.app` URLs continue to work as
  aliases.

## Continuous deploy (already wired up)

Every push to the `main` branch of each repo:

- 404Piyush/bst-library
- 404Piyush/arena-allocator
- 404Piyush/pipe-shell

…rebuilds and redeploys the corresponding Netlify site
automatically.  No further action needed.
