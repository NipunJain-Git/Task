with open('lib/widgets/atoms.dart', 'r') as f:
    lines = f.readlines()

new_lines = []
for line in lines:
    if "export 'ks_text.dart';" in line:
        continue
    new_lines.append(line)

new_lines.insert(0, "export 'ks_text.dart';\n")

with open('lib/widgets/atoms.dart', 'w') as f:
    f.writelines(new_lines)
