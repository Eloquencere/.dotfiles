import fileinput, re

for line in fileinput.input("/etc/pacman.conf", inplace=True):
    if re.match("#Color", line):
        print(line[1:], end='')
        print("ILoveCandy")
    elif re.match("#ParallelDownloads", line):
        print(line[1:], end='')
    else:
        print(line, end='')
