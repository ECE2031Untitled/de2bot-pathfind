# Convert a string into an sequence of DW statements for use in SCASM.

def string2dw(string):
    for c in string:
        print("    DW      " + str(ord(c)))
    print("    DW      0")

string2dw(input())
