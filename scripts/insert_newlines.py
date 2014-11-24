import sys

for line in sys.stdin:
    print(line.replace("__nl__", "\n"), end="")
