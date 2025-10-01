#!/bin/bash
set -e

APP_DIR=/var/www/presentation
BUILD_DIR=dist
NGINX_DIR=/usr/share/nginx/html
GIT_REPO=https://github.com/sarthak078/presentation.git

mkdir -p $APP_DIR
cd $APP_DIR

echo "Using Node.js version: $(node --version)"
echo "Using npm version: $(npm --version)"

# First-time clone or pull updates
if [ ! -d ".git" ]; then
    rm -rf ./* ./.??* 2>/dev/null || true
    git clone $GIT_REPO .
else
    git reset --hard HEAD
    git pull origin main
fi

# Complete cleanup
rm -rf node_modules package-lock.json dist .vite

# Clear npm cache
npm cache clean --force

# Install dependencies
npm install

# Verify Vite installation
echo "Vite version: $(npm list vite --depth=0)"

# Build with verbose output
npm run build -- --verbose

# Deploy to Nginx
sudo rm -rf $NGINX_DIR/*
sudo cp -r $BUILD_DIR/* $NGINX_DIR/
sudo systemctl restart nginx

echo "Deployment done!"
