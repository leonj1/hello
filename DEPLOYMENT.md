# DEPLOYMENT.md

## Platform

**AWS (S3 + CloudFront + Route53)** via [my-deployer](https://github.com/leonj1/my-deployer) — a self-hosted webhook-driven deployment service at `https://webhook-go.joseserver.com`.

## How Deployment Works

1. Push to `main` triggers a GitHub webhook → `https://static-site-webhook.joseserver.com`
2. The deployer clones the repo, detects static HTML files
3. Files are uploaded to an S3 bucket with static website hosting
4. CloudFront CDN is configured in front of S3
5. Route53 DNS record is created under `joseserver.com`

**No build step required** — this is a plain HTML project (`index.html`, `chat.html`).

## Live URL

```
https://leonj1-hello.joseserver.com
```

> Replace with the actual subdomain assigned by the deployer if different.

## Prerequisites

- Repository must be registered in the deployer's allowlist (`POST /repos`)
- GitHub webhook must be configured on the repo pointing to the deployer
- The deployer service must be running (`GET /health` → `{"status":"ok"}`)

## Manual Deployment

If the webhook doesn't fire, you can trigger a deployment by pushing an empty commit:

```bash
git commit --allow-empty -m "trigger deploy"
git push origin main
```

## Environment Variables (Deployer-side)

| Variable | Description |
|---|---|
| `ALLOWED_REPOS` | Must include `leonj1/hello` |
| `GITHUB_WEBHOOK_SECRET` | Shared secret for webhook signature verification |
| `AWS_S3_BUCKET` | Target S3 bucket |
| `AWS_DOMAIN_SUFFIX` | `joseserver.com` |

## Monitoring

Check deployment status via the deployer API:
```bash
curl https://webhook-go.joseserver.com/health
```
