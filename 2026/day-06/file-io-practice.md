## Day 06 – File I/O Practice

## Goal: Practice basic file read/write using fundamental Linux commands.

1. Create a new file
     touch notes.txt
     #This creates an empty file named notes.txt.

2. Write 3 lines into the file

     Write the first line (overwrite if file exists):
          echo "Line 1" > notes.txt

     Append the second line:
          echo "Line 2" >> notes.txt

     Append the third line using tee (displays and writes):
          echo "Line 3" | tee -a notes.txt

3. Read the file
     Read full file using cat:
          cat notes.txt
               Output:

               Line 1
               Line 2
               Line 3

3. Read only the first 2 lines using head:
     head -n 2 notes.txt

          Output:

          Line 1
          Line 2

4. Read only the last 2 lines using tail:
     tail -n 2 notes.txt

          Output:

          Line 2
          Line 3