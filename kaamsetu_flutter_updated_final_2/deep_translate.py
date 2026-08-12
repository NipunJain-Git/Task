import os
import re
from deep_translator import GoogleTranslator
import time

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
translations = { 'hi': {}, 'mr': {}, 'gu': {}, 'bn': {} }

print(f"Translating {len(strings_list)} strings...")

for l in langs:
    translator = GoogleTranslator(source='en', target=l)
    for i, s in enumerate(strings_list):
        try:
            res = translator.translate(s)
            translations[l][s] = res
        except Exception as e:
            print(f"Error {e}")
            translations[l][s] = s
        time.sleep(0.1)
    print(f"Done {l}")

dart_code = "// Auto-generated i18n mapping\n"
dart_code += "const Map<String, Map<String, String>> kI18nAuto = {\n"
for l in langs:
    dart_code += f"  '{l}': {{\n"
    for k, v in translations[l].items():
        k_safe = k.replace("'", "\\'")
        v_safe = str(v).replace("'", "\\'")
        dart_code += f"    '{k_safe}': '{v_safe}',\n"
    dart_code += "  },\n"
dart_code += "};\n"

with open('lib/core/i18n_auto.dart', 'w', encoding='utf-8') as f:
    f.write(dart_code)

print("Done generating i18n_auto.dart")
