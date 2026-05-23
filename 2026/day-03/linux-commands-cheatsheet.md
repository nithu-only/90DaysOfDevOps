Linux Commands Cheat Sheet (Day 03)

📁 File System & Navigation
pwd                     # Show current directory
ls -lah                 # List files (long, all, human-readable)
cd /path                # Change directory
mkdir -p dir/subdir     # Create nested directories
rm -rf dir              # Force delete directory (dangerous)
cp -r src dest          # Copy files/directories
mv old new              # Move or rename files
du -sh *                # Disk usage per item
df -h                   # Disk space usage
stat file               # Detailed file info

📄 File Viewing & Logs
cat file                # Print file content
less file               # Scrollable file viewer
head -n 20 file         # First 20 lines
tail -f app.log         # Follow live logs
wc -l file              # Line count
grep "ERROR" file      # Search text in file

⚙️ Process Management
ps aux                  # List all processes
top                     # Real-time process view
htop                    # Enhanced process monitor
pidof nginx             # Get PID of service
kill PID                # Graceful stop
kill -9 PID             # Force kill
uptime                  # System load & run time
free -m                 # Memory usage (MB)

🌐 Networking & Troubleshooting
ping google.com         # Check connectivity
ip addr                 # Show IP addresses
ip route                # View routing table
ss -tulpn               # Open ports & listening services
curl -I https://site.com# HTTP headers check
dig domain.com          # DNS lookup
traceroute domain.com   # Network path trace

🔐 Permissions & Ownership
chmod 755 file          # Change permissions
chown user:group file   # Change ownership
whoami                  # Current user
id                      # User & group IDs

📦 System & Utilities
uname -a                # Kernel & OS info
history                 # Command history
which node              # Command location
sudo !!                 # Re-run last command as sudo