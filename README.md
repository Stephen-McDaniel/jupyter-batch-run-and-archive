# Jupyter Batch Run AND Archive the Python Code and the Log
Batch-execute Jupyter Notebooks from the command line: automatically convert them to Python scripts, record and append execution logs, and capture exact runtime (in seconds) for seamless archival and reproducibility.

# Motivation
Running Jupyter notebooks in VS Code, I want to easily start and run long-running notebooks in the background

# Before
/path/to/file/Notebook1.ipynb

# Run it!
/path/to/script/python3_batch.sh "/path/to/file/Notebook1.ipynb"

# "Magic" happens
A log directory is created, if it doesn't exist, at "/path/to/file/logs".

The Python script is written there, with a date time in the file name (archival!)

All is run.

The log is appended as comments at the bottom of the Python file.

And the run time in seconds is appended to the bottom of the Python file.
