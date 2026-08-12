import os
import re

dart_files = []
for root, dirs, files in os.walk('lib/screens'):
    for file in files:
        if file.endswith('.dart'):
            dart_files.append(os.path.join(root, file))

dart_files.append('lib/widgets/atoms.dart')
dart_files.append('lib/widgets/ks_text.dart')

for path in dart_files:
    if path == 'lib/widgets/ks_text.dart':
        continue
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()
        
    orig = content
    # Replace Text( with KsText( ensuring we don't replace inside KsText itself
    content = re.sub(r'\bText\(', r'KsText(', content)
    
    if orig != content:
        with open(path, 'w', encoding='utf-8') as f:
            f.write(content)
