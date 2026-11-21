#!/bin/bash
set -e

# 1. Start Nginx immediately on ports 10000 and 5000 so Render port scan succeeds instantly
echo "==> Starting Nginx on ports 10000 and 5000..."
nginx

# 2. Start Backend directly with Node (trimmed to Facebook, Instagram, TikTok, YouTube)
echo "==> Starting Backend on internal port 3000..."
cd /app/apps/backend
PORT=3000 BACKEND_INTERNAL_PORT=3000 node --experimental-require-module --max-old-space-size=220 ./dist/apps/backend/src/main.js &
BACKEND_PID=$!

# 3. Start Frontend directly with Node on internal port 4200
echo "==> Starting Frontend on internal port 4200..."
cd /app/apps/frontend
node --max-old-space-size=140 ../../node_modules/next/dist/bin/next start -p 4200 &
FRONTEND_PID=$!

echo "==> Services active (Backend PID: $BACKEND_PID, Frontend PID: $FRONTEND_PID). Container is live!"

# 4. Wait for processes and keep container running
wait -n $BACKEND_PID $FRONTEND_PID
