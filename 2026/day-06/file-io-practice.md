# Day 06 – Linux Fundamentals: Read and Write Text Files

## Task
This is a **continuation of Day 05**, but much simpler.

Today’s goal is to **practice basic file read/write** using only fundamental commands.

You will create a small text file and practice:
- Creating a file
  ```
  # file can be created using touch command
  $ touch notes.txt
  ```

- Writing text to a file
  ```python
  """Method 1:
  To write content into file we need text editor [for eg: nano, vim, micro]
  """
  $ nano notes.txt
  """ Method 2:
  You can redirect the output of one command into file using > operator
  """
  $ echo "hello" > notes.txt # Output of echo "hello" redirected to notes.txt

  ```
- Appending new lines
  ``` python
  """To append content to a file can be done in 2 Methods
    Method 1: Using any text editor
    """
    $ nano notes.txt

    """
    Method 2: using >> operator to append the output back of the contents of the file
    """

    $ echo "hello" >> notes.txt # Here output of echo "hello" appended to the file notes.txt.

    ```
- Reading the file back
  ```python
    # To read the file we can use cat 
    $ cat notes.txt
    # To read first 10 lines of file
    $ head notes.txt
    # To read last 10 lines of file
    $ tail notes.txt

    # tee command receives input, saves it to a file, and passes the same data to the next command or terminal.
    $ ls -l | tee notes.txt # Here the output of ls -l redirected to notes.txt using tee command and also the outputs are passed to the terminal
  ```


## Why This Matters for DevOps
Reading and writing files is a daily task in DevOps.

Logs, configs, and scripts are all text files.  
If you can handle files quickly, you can debug and automate faster.
