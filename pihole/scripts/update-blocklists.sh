#!/bin/bash

# Pi-hole Blocklist Update Script
# Updates Pi-hole blocklists and gravity using Pi-hole's built-in adlist management

set -e

echo "$(date): Starting Pi-hole blocklist update"

# Define additional blocklists to add to Pi-hole
# These will be added to Pi-hole's adlist database
ADDITIONAL_BLOCKLISTS=(
    "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
    "https://someonewhocares.org/hosts/zero/hosts"
    "https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=0&mimetype=plaintext"
    "https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/spy.txt"
    "https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/MobileFilter/sections/adservers.txt"
)

# Add blocklists to Pi-hole's adlist database if they're not already there
echo "Adding additional blocklists to Pi-hole..."
for url in "${ADDITIONAL_BLOCKLISTS[@]}"; do
    echo "Adding blocklist: $url"
    # Use Pi-hole's API to add the blocklist (this checks if it already exists)
    docker exec pihole sqlite3 /etc/pihole/gravity.db \
        "INSERT OR IGNORE INTO adlist (address, enabled, comment) VALUES ('$url', 1, 'Auto-added by update script');"
done

# Update gravity (this downloads and processes all configured blocklists)
echo "Updating Pi-hole gravity..."
docker exec pihole pihole -g

# Reload Pi-hole lists
echo "Reloading Pi-hole lists..."
docker exec pihole pihole reloadlists

echo "$(date): Pi-hole blocklist update completed"
