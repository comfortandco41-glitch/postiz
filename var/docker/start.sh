#!/bin/bash

# 1. Start Nginx immediately so Render detects port 5000 right away
echo "==> Starting Nginx on port 5000..."
nginx

# 2. Sync database schema (non-blocking if already in sync)
echo "==> Verifying database schema..."
pnpm run prisma-db-push || true

# 3. Start backend and frontend with PM2
echo "==> Starting backend service..."
cd /app/apps/backend && pm2 start pnpm --name backend -- start

echo "==> Starting frontend service..."
cd /app/apps/frontend && pm2 start pnpm --name frontend -- start

# 4. Stream logs so the container stays alive and logs are visible on Render
echo "==> Services launched. Streaming PM2 logs..."
cd /app && pm2 logs