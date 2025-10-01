#!/bin/bash
set -e

APP_DIR=/var/www/presentation
GIT_REPO=https://github.com/sarthak078/presentation.git
BUILD_DIR=dist
NGINX_DIR=/usr/share/nginx/html

# Ensure app directory exists
sudo mkdir -p "$APP_DIR"
sudo chown -R $(whoami):$(whoami) "$APP_DIR"
cd "$APP_DIR"

# Determine how to get repo
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

# Make deploy.sh executable
chmod +x deploy.sh || true

# Clean previous build
rm -rf node_modules package-lock.json "$BUILD_DIR" .vite
npm cache clean --force

# Install dependencies and build
npm install
npm run build -- --verbose

# Deploy to Nginx
sudo rm -rf "$NGINX_DIR"/*
sudo cp -r "$BUILD_DIR"/* "$NGINX_DIR"/
sudo systemctl restart nginx

echo "Deployment complete!"
