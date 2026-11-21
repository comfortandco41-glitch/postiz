#!/bin/bash

# 1. Start Nginx immediately on port 5000 so Render detects port binding
echo "==> Starting Nginx on port 5000..."
nginx

# 2. Sync database schema (non-blocking if already in sync)
echo "==> Verifying database schema..."
pnpm run prisma-db-push || true

# 3. Start backend directly with PM2 (memory: 320MB for Nest module bootstrap)
echo "==> Starting backend service..."
cd /app/apps/backend
pm2 start ./dist/apps/backend/src/main.js \
  --name backend \
  --node-args="--experimental-require-module --max-old-space-size=320"

# 4. Start frontend directly with PM2 (memory: 150MB)
echo "==> Starting frontend service..."
cd /app/apps/frontend
pm2 start ../../node_modules/next/dist/bin/next \
  --name frontend \
  --node-args="--max-old-space-size=150" \
  -- start -p 4200

# 5. Stream logs so the container stays alive and logs are visible on Render
echo "==> Services launched. Streaming PM2 logs..."
pm2 logs