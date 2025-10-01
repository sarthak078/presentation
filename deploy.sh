#!/bin/bash
set -e

APP_DIR=/var/www/presentation
GIT_REPO=https://github.com/sarthak078/presentation.git
BUILD_DIR=dist
NGINX_DIR=/usr/share/nginx/html

# Create app dir if missing and set permissions
if [ ! -d "$APP_DIR" ]; then
    sudo mkdir -p "$APP_DIR"
    sudo chown -R $(whoami):$(whoami) "$APP_DIR"
fi

cd "$APP_DIR"

# First-time clone or pull updates
if [ ! -d .git ]; then
    git clone "$GIT_REPO" .
else
    git reset --hard HEAD
    git pull origin main
fi

# Make sure deploy.sh is executable
chmod +x deploy.sh

# Complete cleanup
rm -rf node_modules package-lock.json "$BUILD_DIR" .vite
npm cache clean --force

# Install dependencies
npm install

# Build the app
npm run build -- --verbose

# Deploy to Nginx
sudo rm -rf "$NGINX_DIR"/*
sudo cp -r "$BUILD_DIR"/* "$NGINX_DIR"/
sudo systemctl restart nginx

echo "Deployment done!"
