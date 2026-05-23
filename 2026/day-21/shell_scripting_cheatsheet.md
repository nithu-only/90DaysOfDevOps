**\### Day 21 – Shell Scripting Cheat Sheet**

**\## Quick Reference Table**

| **Topic**     | **Key Syntax**               | **Example** |
| Variable      | VAR=”value”                  | NAME=”DevOps” |
| Argument      | $1, S2                       | ./script.sh prod |
| If            | If \[ condition \]; then     | If \[-f file \]; then |
| For loop      | For I in list; do            | For I in 1,2,3; do |
| Function      | Name() {}                    | Greet() {echo “Hi”;} |
| Grep          | Grep pattern file            | Grep –I error log.txt |
| Awk           | Awk ‘{print $1}’ file        | Awk –f: ‘{print $1}’ /etc/passwd |
| Sed           | Sed ‘s/old/new/g’            | Sed –I ‘s/foo/bar/g’ config.txt |

1.  **Basics:**
    - **Shebang**
        - #!/bin/bash
        - Specifies script interpreter.
    - **Run a Script**
        - chmod +x script.sh
        - ./script.sh
        - bash script.sh
    - **Comments**
        - \# single line
        - echo "Hello" # inline comment
    - **Variables**
        - NAME="Axata"
        - echo $NAME
        - echo "$NAME" # preserves spaces
        - echo '$NAME' # literal
    - **Read Input**
        - read -p "Enter name: " NAME
        - echo "Hi $NAME"
    - **Command-Line Arguments**
        - echo $0 # script name
        - echo $1 # first arg
        - echo $# # arg count
        - echo $@ # all args
        - echo $? # last exit code

2.  **Operators & Conditionals:**

- **String Comparisons**
    - \[ "$a" = "$b" \]
    - \[ "$a" != "$b" \]
    - \[ -z "$a" \] # empty
    - \[ -n "$a" \] # not empty
- **Integer Comparisons**
    - \[ $a -eq $b \]
    - \[ $a -ne $b \]
    - \[ $a -lt $b \]
    - \[ $a -gt $b \]
    - \[ $a -le $b \]
    - \[ $a -ge $b \]
- **File Tests**
    - \[ -f file \] # file exists
    - \[ -d dir \] # directory
    - \[ -e path \] # exists
    - \[ -r file \] # readable
    - \[ -w file \] # writable
    - \[ -x file \] # executable
    - \[ -s file \] # not empty
- **If / Elif / Else**
    - if \[ -f file \]; then
    - echo "exists"
    - elif \[ -d file \]; then
    - echo "directory"
    - else
    - echo "not found"
    - fi
- **Logical Operators**
    - \[ cond1 \] && echo "true"
    - \[ cond1 \] || echo "false"
    - \[ ! cond \] && echo "not true"
- **Case Statement**
    - case $1 in
        echo "Starting";;
        echo "Stopping";;
        echo "Usage: start|stop";;
        esac

3.  **Loops**

    - **For Loop (list)**

    for i in 1 2 3; do

    echo $i

    done

    - **For Loop (C-style)**

    for ((i=1; i<=5; i++)); do

    echo $i

    done

    - **While Loop**

    count=1

    while \[ $count -le 3 \]; do

    echo $count

    ((count++))

    done

    - **Until Loop**

    n=1

    until \[ $n -gt 3 \]; do

    echo $n

    ((n++))

    done

    - **Break & Continue**

    for i in {1..5}; do

    \[ $i -eq 3 \] && continue

    \[ $i -eq 5 \] && break

    echo $i

    done

    - **Loop Files**

    for file in \*.log; do

    echo $file

    done

    - **Loop Command Output**

    ps aux | while read line; do

    echo $line

    done

4.  **Functions**

    **Define & Call**

    greet() {

    echo "Hello"

    }

    Greet

    **Arguments**

    sum() {

    echo $(($1 + $2))

    }

    sum 3 4

    **Return vs Echo**

    get_num() {

    return 5

    }

    echo $? # return value

    get_text() {

    echo "hello"

    }

    val=$(get_text)

    **Local Variables**

    myfunc() {

    local var="inside"

    echo $var

    }

5.  **Text Processing Commands**

    **grep**

    grep "error" log.txt

    grep -i "error" log.txt

    grep -r "error" /var/log

    grep -n "error" log.txt

    grep -c "error" log.txt

    grep -v "info" log.txt

    grep -E "fail|error" log.txt

    **awk**

    awk '{print $1}' file

    awk -F: '{print $1}' /etc/passwd

    awk '$3 > 1000' file

    awk 'BEGIN{print "Start"} {print $1} END{print "End"}' file

    **sed**

    sed 's/foo/bar/' file

    sed 's/foo/bar/g' file

    sed -i 's/foo/bar/g' file

    sed '2d' file

    **cut**

    cut -d',' -f1 file.csv

    **sort & uniq**

    sort file.txt

    sort -n numbers.txt

    sort -r file.txt

    sort file.txt | uniq

    uniq -c file.txt

    **tr**

    echo "HELLO" | tr 'A-Z' 'a-z'

    tr -d '\\r' < file.txt

    **wc**

    wc -l file

    wc -w file

    wc -c file

    **head & tail**

    head -n 10 file

    tail -n 20 file

    tail -f app.log

6.  **Useful One-Liners**

    **Delete files older than 7 days**

    find /path -type f -mtime +7 –delete

    **Count lines in all logs**

    cat \*.log | wc –l

    **Replace text in multiple files**

    sed -i 's/old/new/g' \*.conf

    **Check if service is running**

    systemctl is-active nginx

    **Disk usage alert**

    df -h | awk '$5>80 {print "Disk nearly full:", $0}'

    **Tail log & filter errors**

    tail -f app.log | grep ERROR

7.  **Error Handling & Debugging**

    **Exit Codes**

    echo $? # last status

    exit 0 # success

    exit 1 # error

    **Safer Scripts**

    set -e # exit on error

    set -u # unset vars error

    set -o pipefail

    set -x # debug trace

    **Trap Cleanup**

    cleanup() {

    echo "Cleaning up..."

    }

    trap cleanup EXIT

# Pro Tips

- Quote variables to prevent word splitting
- Use set -euo pipefail in production scripts
- Use functions to keep scripts modular
- Log output for debugging (>> logfile)
- Test scripts with bash -x script.sh
