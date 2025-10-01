#!/bin/bash
set -e

# --- Configuration ---
APP_DIR=/var/www/presentation
GIT_REPO=https://github.com/sarthak078/presentation.git
BUILD_DIR=dist
NGINX_DIR=/usr/share/nginx/html

# --- Prepare App Directory ---
if [ ! -d "$APP_DIR" ]; then
    echo "Creating app directory..."
    sudo mkdir -p "$APP_DIR"
    sudo chown -R $(whoami):$(whoami) "$APP_DIR"
fi

cd "$APP_DIR"

# --- Clone or Update Repo ---
if [ ! -d .git ]; then
    echo "Cloning repository..."
    git clone "$GIT_REPO" .
else
    echo "Updating repository..."
    git reset --hard HEAD
    git pull origin main
fi

# --- Build & Deploy ---
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
