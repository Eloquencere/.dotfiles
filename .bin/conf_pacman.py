import fileinput

for line in fileinput.input("/etc/pacman.conf", inplace=True):
    if line.startswith("#Color"):
        print(line[1:], end='')
        print("ILoveCandy")
    elif line.startswith("#ParallelDownloads"):
        print(line[1:], end='')
    else:
        print(line, end='')
