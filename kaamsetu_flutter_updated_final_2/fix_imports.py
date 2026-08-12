import os
import re

for root, dirs, files in os.walk('lib/screens'):
    for file in files:
        if file.endswith('.dart'):
            path = os.path.join(root, file)
            with open(path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            if 'KsText' in content and 'import ' not in content.split('KsText')[0][-50:]:
                # Check if atoms is imported
                if 'atoms.dart' not in content:
                    depth = path.count('/') - 1
                    prefix = '../' * depth
                    import_stmt = f"import '{prefix}widgets/atoms.dart';\n"
                    # insert after first import
                    content = re.sub(r'(import .*;\n)', r'\1' + import_stmt, content, count=1)
                    with open(path, 'w', encoding='utf-8') as f:
                        f.write(content)
