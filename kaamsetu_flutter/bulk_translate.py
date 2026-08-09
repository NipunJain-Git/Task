import os
import re
import json
import time
from googletrans import Translator

translator = Translator()

dart_files = []
for root, dirs, files in os.walk('lib/screens'):
    for file in files:
        if file.endswith('.dart'):
            dart_files.append(os.path.join(root, file))
            
dart_files.append('lib/widgets/atoms.dart')
dart_files.append('lib/widgets/ks_text.dart')

strings = set()

for path in dart_files:
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    matches = re.findall(r"KsText\(\s*'([^'$]+)'\s*(?:,|\))", content)
    matches += re.findall(r'KsText\(\s*"([^"$]+)"\s*(?:,|\))', content)
    
    for m in matches:
        if m.strip():
            strings.add(m.strip())

strings_list = list(strings)
langs = ['hi', 'mr', 'gu', 'bn']

# Read existing i18n
with open('lib/core/i18n.dart', 'r') as f:
    orig_i18n = f.read()

translations = { 'hi': {}, 'mr': {}, 'gu': {}, 'bn': {} }

print(f"Translating {len(strings_list)} strings in bulk...")

for l in langs:
    try:
        # bulk translate
        res = translator.translate(strings_list, dest=l)
        for i, r in enumerate(res):
            translations[l][strings_list[i]] = r.text
        print(f"Translated to {l}")
    except Exception as e:
        print(f"Error for {l}: {e}")
        # fallback
        for s in strings_list:
            translations[l][s] = f"{s} [{l}]"
    time.sleep(1)

# Generate dart code
dart_code = "// Auto-generated i18n mapping\n"
dart_code += "const Map<String, Map<String, String>> kI18nAuto = {\n"
for l in langs:
    dart_code += f"  '{l}': {{\n"
    for k, v in translations[l].items():
        k_safe = k.replace("'", "\\'")
        v_safe = v.replace("'", "\\'")
        dart_code += f"    '{k_safe}': '{v_safe}',\n"
    dart_code += "  },\n"
dart_code += "};\n"

with open('lib/core/i18n_auto.dart', 'w', encoding='utf-8') as f:
    f.write(dart_code)

print("Done generating i18n_auto.dart")
