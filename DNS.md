# DNS

The three Netlify sites are deployed and the custom-domain
fields are set on Netlify. The sites will not actually
serve on `*.404piyush.me` until CNAME records are in place
at the DNS provider for `404piyush.me`.

## CNAMEs to add

| Type | Name | Target | TTL |
|---|---|---|---|
| CNAME | `bst-library` | `bst-library.netlify.app` | 300 |
| CNAME | `arena-allocator` | `arena-allocator.netlify.app` | 300 |
| CNAME | `pipe-shell` | `pipe-shell.netlify.app` | 300 |

Some DNS providers label the `Name` field as `Host` or
`Subdomain`. If CNAME on a subdomain is not supported,
use an ALIAS or ANAME record with the same target.

## Verify

After 5 to 30 minutes for DNS propagation:

```sh
for sub in bst-library arena-allocator pipe-shell; do
    echo "=== $sub.404piyush.me ==="
    dig +short "$sub.404piyush.me" CNAME
    curl -sI "https://$sub.404piyush.me" | head -3
done
```

Expected output:

- CNAME record points to `<sub>.netlify.app`
- HTTPS returns `HTTP/2 200` with a
  `Strict-Transport-Security` header, which proves the
  Let's Encrypt certificate was auto-provisioned

## What happens on Netlify's side

Once the CNAMEs are in place and Netlify detects them:

1. Netlify auto-provisions a Let's Encrypt TLS certificate
   via the DNS-01 challenge. This takes about 2 minutes.
2. HTTPS on the custom domain is live about 5 minutes
   after DNS.
3. The original `*.netlify.app` URLs continue to work as
   aliases.
