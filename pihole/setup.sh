#!/bin/bash

# Pi-hole Setup Script
# This script ensures Pi-hole is configured correctly with the password from .env

set -e

# Load environment variables
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
else
    echo "Error: .env file not found!"
    exit 1
fi

echo "Setting up Pi-hole with configuration from .env file..."

# Create directories if they don't exist
mkdir -p "${PIHOLE_BASE_DIR}"/{etc-pihole,etc-dnsmasq.d,logs,scripts}

# Start Pi-hole services
echo "Starting Pi-hole services..."
docker-compose up -d

# Wait for Pi-hole to be ready
echo "Waiting for Pi-hole to initialize..."
sleep 10

# Check if Pi-hole is running
if ! docker exec pihole pihole status | grep -q "Pi-hole blocking is enabled"; then
    echo "Waiting a bit more for Pi-hole to fully start..."
    sleep 10
fi

echo "✓ Pi-hole setup complete!"
echo "✓ Admin interface: http://localhost:1010/admin"
echo "✓ DNS server: ${PIHOLE_IP}:53"
