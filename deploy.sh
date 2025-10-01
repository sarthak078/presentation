#!/bin/bash
set -e

APP_DIR=/var/www/presentation
GIT_REPO=https://github.com/sarthak078/presentation.git
BUILD_DIR=dist
NGINX_DIR=/usr/share/nginx/html

# --- Prepare App Directory ---
sudo mkdir -p "$APP_DIR"
sudo chown -R $(whoami):$(whoami) "$APP_DIR"
cd "$APP_DIR"

# --- Clone or Update Repo ---
if [ -d .git ]; then
    echo "Updating existing repository..."
    git reset --hard HEAD
    git pull origin main
elif [ "$(ls -A)" ]; then
    echo "Directory not empty but no Git repo, cleaning up..."
    rm -rf ./*
    git clone "$GIT_REPO" .
else
    echo "Cloning repository into empty directory..."
    git clone "$GIT_REPO" .
fi

# --- Install Node.js 20.x if needed ---
NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 20 ]; then
    echo "Upgrading Node.js to v20..."
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt-get install -y nodejs
fi

# --- Make deploy.sh executable ---
chmod +x deploy.sh || true

# --- Clean old build ---
rm -rf node_modules package-lock.json "$BUILD_DIR" .vite
npm cache clean --force

# --- Install dependencies ---
npm install
npm install vite@5.4.8 --save-dev
npm install @vitejs/plugin-react@4.3.1 --save-dev

# --- Build app ---
npm run build

# --- Deploy to Nginx ---
sudo rm -rf "$NGINX_DIR"/*
sudo cp -r "$BUILD_DIR"/* "$NGINX_DIR"/
sudo systemctl restart nginx

echo "Deployment complete!"
