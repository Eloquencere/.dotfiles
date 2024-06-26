import fileinput, re

for line in fileinput.input("/etc/default/grub", inplace=True):
  if line.startswith("GRUB_DEFAULT="):
    print(line[:line.find('=')+1] + '0')
  elif line.startswith("GRUB_TIMEOUT="):
    print(line[:line.find('=')+1] + '0')
  elif line.startswith("GRUB_TIMEOUT_STYLE="):
    print(line[:line.find('=')+1] + "hidden")
  else:
    print(line, end='')
