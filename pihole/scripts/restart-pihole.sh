#!/bin/bash

# Pi-hole Restart Script
# Restarts Pi-hole container to ensure clean state after updates

set -e

echo "$(date): Restarting Pi-hole container"

# Restart the Pi-hole container
docker restart pihole

# Wait for it to be ready
sleep 30

# Verify Pi-hole is working
if docker exec pihole pihole status | grep -q "Pi-hole blocking is enabled"; then
    echo "$(date): Pi-hole restart completed successfully"
else
    echo "$(date): Warning - Pi-hole may not be fully ready yet"
fi
