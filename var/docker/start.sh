#!/bin/bash
set -e

echo "==> Running Prisma DB push..."
pnpm run prisma-db-push || true

echo "==> Starting backend and frontend with PM2..."
pnpm --filter ./apps/backend --filter ./apps/frontend run pm2

echo "==> Waiting for frontend to be ready on port 4200..."
for i in $(seq 1 45); do
  if (echo > /dev/tcp/127.0.0.1/4200) >/dev/null 2>&1; then
    echo "==> Frontend is ready!"
    break
  fi
  sleep 1
done

echo "==> Starting Nginx on port 5000..."
nginx

echo "==> Container ready. Tailing PM2 logs..."
pm2 logs