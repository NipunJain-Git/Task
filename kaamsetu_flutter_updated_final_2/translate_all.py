import os
import re
import json
from googletrans import Translator

translator = Translator()

dart_files = []
for root, dirs, files in os.walk('lib/screens'):
    for file in files:
        if file.endswith('.dart'):
            dart_files.append(os.path.join(root, file))
            
# Include atoms
dart_files.append('lib/widgets/atoms.dart')
dart_files.append('lib/screens/shared/edit_profile_screen.dart')

strings_to_translate = set()

for path in dart_files:
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # find Text('something') or Text("something")
    # exclude strings with $ (interpolation)
    matches = re.findall(r"Text\(\s*'([^'$]+)'\s*(?:,|\))", content)
    matches += re.findall(r'Text\(\s*"([^"$]+)"\s*(?:,|\))', content)
    
    # also find labels in buttons: label: const Text('something') -> label: Text('something')
    
    for m in matches:
        if m.strip():
            strings_to_translate.add(m)

# Let's also parse the existing i18n.dart to not re-translate
i18n_path = 'lib/core/i18n.dart'
with open(i18n_path, 'r', encoding='utf-8') as f:
    i18n_content = f.read()

langs = ['hi', 'mr', 'gu', 'bn']
translations = { 'en': {}, 'hi': {}, 'mr': {}, 'gu': {}, 'bn': {} }

print(f"Found {len(strings_to_translate)} strings to translate.")

# We will just generate a new i18n map
for s in strings_to_translate:
    translations['en'][s] = s
    for l in langs:
        try:
            res = translator.translate(s, dest=l)
            translations[l][s] = res.text
        except Exception as e:
            print(f"Error translating {s} to {l}: {e}")
            translations[l][s] = s

with open('translations.json', 'w', encoding='utf-8') as f:
    json.dump(translations, f, ensure_ascii=False, indent=2)

# Now, we rewrite the files to use tr()
# We must ensure AppProvider and i18n are imported
import_app_provider = "import '../../providers/app_provider.dart';\n"
import_i18n = "import '../../core/i18n.dart';\n"

for path in dart_files:
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()
        
    orig_content = content
    
    # Replace const Text('...') with Text(tr(context.watch<AppProvider>().lang, '...'))
    content = re.sub(r"const\s+Text\(\s*'([^'$]+)'", r"Text(tr(context.watch<AppProvider>().lang, '\1')", content)
    content = re.sub(r'const\s+Text\(\s*"([^"$]+)"', r'Text(tr(context.watch<AppProvider>().lang, "\1")', content)
    
    # Replace Text('...') with Text(tr(context.watch<AppProvider>().lang, '...'))
    # Careful not to replace already replaced ones, so we only replace if not preceded by tr(
    # But regex is tricky. Let's just do a naive replace and fix double wrapping
    
    def replacer(m):
        val = m.group(1)
        if val not in strings_to_translate: return m.group(0)
        return f"Text(tr(context.watch<AppProvider>().lang, '{val}'"
        
    content = re.sub(r"Text\(\s*'([^'$]+)'", replacer, content)
    content = re.sub(r'Text\(\s*"([^"$]+)"', replacer, content)
    
    if orig_content != content:
        if 'import \'../../core/i18n.dart\';' not in content and 'import \'../../core/i18n.dart\' ' not in content:
            content = content.replace("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';\nimport '../../core/i18n.dart';")
        if 'import \'../../providers/app_provider.dart\';' not in content:
            content = content.replace("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';\nimport '../../providers/app_provider.dart';")
        if 'import \'package:provider/provider.dart\';' not in content:
            content = content.replace("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';\nimport 'package:provider/provider.dart';")
            
        with open(path, 'w', encoding='utf-8') as f:
            f.write(content)

print("Done translating and rewriting files.")
