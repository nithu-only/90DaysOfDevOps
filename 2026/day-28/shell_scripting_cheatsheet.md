# Shell Scripting Cheat Sheet

## Script Basics
```
#!/bin/bash              # Shebang
chmod +x script.sh       # Make script executable
./script.sh              # Run script
```

## Variables & Arguments
```
VAR="value"
echo $VAR
echo "First arg: $1, Second arg: $2"
read -p "Enter value: " input
```

## Conditional Statements
```
# If-Else
if [ condition ]; then
  commands
elif [ condition ]; then
  commands
else
  commands
fi

# Case
case "$var" in
  pattern1) commands ;;
  pattern2) commands ;;
  *) commands ;;
esac
```

## Loops
```
# For loop
for i in {1..5}; do
  echo $i
done

# While loop
while [ condition ]; do
  commands
done

# Until loop
until [ condition ]; do
  commands
done
```

## Functions
```
my_func() {
  echo "Function called with $1"
  return 0
}

my_func "argument"
```

## Text Processing
```
grep "pattern" file
awk '{print $1}' file
sed 's/old/new/g' file
sort file
uniq file
```

## Error Handling
```
set -euo pipefail
trap 'echo "Error on line $LINENO"; exit 1' ERR
```

## File Operations
```
cp source dest
mv source dest
rm file
mkdir dir
touch file
```

## Permissions & Ownership
```
chmod 755 file     # rwxr-xr-x
chown user:group file
```

## Cron Jobs
```
crontab -e
# Example: run script every day at 3 AM
0 3 * * * /home/user/script.sh
```

## Useful Commands
```
pwd      # current directory
ls -la   # list files
df -h    # disk usage
du -sh   # directory size
top      # CPU/Memory usage
free -h  # memory usage
ping host
curl url
```

