# Pi-hole Docker Setup for M1 Mac Mini

This is a comprehensive Pi-hole setup optimized for M1 Mac Mini with automatic blocklist updates and proper memory allocation.

## 🚀 Quick Start

1. **Edit Configuration**:
   ```bash
   # Edit .env file with your specific settings
   nano .env
   ```

2. **Run Setup**:
   ```bash
   ./setup.sh
   ```

3. **Access Pi-hole**:
   - Web Interface: http://localhost:1010/admin
   - Password: (as set in `.env` file)

## 📁 Directory Structure

```
/Users/mittalmak/dev/docker/pihole/
├── .env                    # Configuration variables
├── docker-compose.yml      # Docker Compose configuration
├── setup.sh               # Initial setup script
├── etc-pihole/            # Pi-hole configuration data
├── etc-dnsmasq.d/         # DNSMasq configuration
├── logs/                  # Pi-hole logs
├── scripts/               # Automation scripts
│   ├── update-blocklists.sh
│   └── restart-pihole.sh
└── custom-blocklists/     # Custom blocklist files
```

## ⚙️ Configuration

### Environment Variables (.env)

- `PIHOLE_BASE_DIR`: Base directory for all Pi-hole data
- `PIHOLE_IP`: Your Mac's IP address (update this!)
- `ROUTER_IP`: Your router's IP address
- `NETWORK_CIDR`: Your network CIDR (e.g., 10.0.0.0/24)
- `PIHOLE_PASSWORD`: Admin web interface password
- `ADMIN_EMAIL`: Your email address
- `TIMEZONE`: Your timezone

### Router/DHCP Configuration

1. Set your router's DNS server to your Mac's IP (${PIHOLE_IP})
2. Or configure individual devices to use ${PIHOLE_IP} as DNS

## 🔄 Automation Features

### Automatic Blocklist Updates
- **Schedule**: Every Sunday at 2:00 AM
- **Action**: Downloads and updates 4-5 different blocklist sources
- **Location**: Custom lists saved to `custom-blocklists/`

### Container Restart
- **Schedule**: Every Sunday at 3:00 AM (after blocklist updates)
- **Purpose**: Ensures clean state after updates

### Watchtower Exclusion
- Pi-hole is excluded from automatic updates via Watchtower
- This prevents unexpected Pi-hole version updates

## 🧠 Memory Optimization

### Resource Limits
- **Memory Limit**: 512MB (sufficient for 4-5 blocklists)
- **Memory Reservation**: 256MB
- **CPU Limit**: 0.5 cores
- **CPU Reservation**: 0.25 cores

### Optimized Settings
- `FTLCONF_MAXDBDAYS`: 365 days of query history
- `FTLCONF_MAXLOGAGE`: 24 hours of log retention
- Database import enabled for better performance

## 🛠️ Management Commands

### Manual Operations
```bash
# Start Pi-hole
docker-compose up -d

# Stop Pi-hole
docker-compose down

# View logs
docker-compose logs -f pihole

# Update blocklists manually
./scripts/update-blocklists.sh

# Restart Pi-hole manually
./scripts/restart-pihole.sh

# Change password
docker exec pihole pihole setpassword 'NewPassword'

# Check status
docker exec pihole pihole status
```

### Backup Configuration
```bash
# Backup Pi-hole configuration
tar -czf pihole-backup-$(date +%Y%m%d).tar.gz etc-pihole/

# Restore from backup
tar -xzf pihole-backup-YYYYMMDD.tar.gz
```

## 🔧 Troubleshooting

### Password Issues
If the password isn't set correctly:
```bash
docker exec pihole pihole setpassword 'YourPassword'
```

### DNS Not Working
1. Check if Pi-hole is running: `docker-compose ps`
2. Verify your Mac's IP in `.env` file
3. Check router DNS configuration
4. Test DNS resolution: `nslookup google.com ${PIHOLE_IP}`

### Port Conflicts
If port 80 is in use, the compose file uses port 1010 instead.
Access via: http://localhost:1010/admin

### Memory Issues
Monitor memory usage:
```bash
docker stats pihole
```

## 📊 Blocklist Sources

The setup includes these high-quality blocklist sources:
1. **StevenBlack hosts** - Comprehensive ad/malware blocking
2. **someonewhocares** - Additional protection
3. **AdGuard Mobile Filter** - Mobile-specific ads
4. **Peter Lowe's List** - Ad server blocking
5. **WindowsSpyBlocker** - Windows telemetry blocking

## 🔒 Security Notes

- Change the default password in `.env`
- Consider adding `.env` to `.gitignore` if using version control
- Regularly update Pi-hole: `docker exec pihole pihole -up`
- Monitor logs for suspicious activity

## 📈 Performance Tips

- Use SSD storage for better I/O performance
- Monitor resource usage with `docker stats`
- Clean old logs periodically
- Consider increasing memory limits if handling many clients

---

**Note**: This setup is optimized for M1 Mac Mini and excludes Pi-hole from Watchtower auto-updates for stability.
