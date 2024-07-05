import sys

file = sys.argv[1]
key_section = sys.argv[2]
text_to_append = sys.stdin.read()

variable_section = "# Local"
stitched_lines = []

with open(file, 'r') as file_handle:
  for line in file_handle:
    stitched_lines.append(line)
    if line.startswith(variable_section): break
  else:
    stitched_lines.append(variable_section+'\n\n')
  if key_section != variable_section:
    for line in file_handle:
      stitched_lines.append(line)
      if line.startswith(key_section): break
    else:
      stitched_lines.append(key_section+'\n')
  for line in file_handle:
    if line == '\n': break
    stitched_line.append(line)
  
  stitched_lines.append(f"{text_to_append}\n")

  for line in file_handle:
    stitched_lines.append(line)

with open(file, 'w') as file_handle:
  file_handle.write(''.join(stitched_lines))
      
