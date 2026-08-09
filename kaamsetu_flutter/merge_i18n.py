with open('lib/core/i18n.dart', 'r') as f:
    orig = f.read()
    
with open('lib/core/i18n_auto.dart', 'r') as f:
    auto = f.read()

import re
auto_map = {}
current_lang = None
for line in auto.split('\n'):
    if line.startswith("  'hi': {"): current_lang = 'hi'
    elif line.startswith("  'mr': {"): current_lang = 'mr'
    elif line.startswith("  'gu': {"): current_lang = 'gu'
    elif line.startswith("  'bn': {"): current_lang = 'bn'
    elif line.startswith("  },"): current_lang = None
    elif current_lang and line.strip().startswith("'"):
        if current_lang not in auto_map:
            auto_map[current_lang] = []
        auto_map[current_lang].append(line.rstrip())

new_orig = ""
for line in orig.split('\n'):
    if line.startswith("  'hi': {"):
        new_orig += line + "\n"
        new_orig += "\n".join(auto_map['hi']) + "\n"
    elif line.startswith("  'mr': {"):
        new_orig += line + "\n"
        new_orig += "\n".join(auto_map['mr']) + "\n"
    elif line.startswith("  'gu': {"):
        new_orig += line + "\n"
        new_orig += "\n".join(auto_map['gu']) + "\n"
    elif line.startswith("  'bn': {"):
        new_orig += line + "\n"
        new_orig += "\n".join(auto_map['bn']) + "\n"
    else:
        new_orig += line + "\n"

# also add to en
en_entries = []
for line in auto_map['hi']:
    # extract key
    key = line.split(':')[0].strip()[1:-1]
    key_safe = key.replace("'", "\\'")
    en_entries.append(f"    '{key_safe}': '{key_safe}',")

new_orig2 = ""
for line in new_orig.split('\n'):
    if line.startswith("  'en': {"):
        new_orig2 += line + "\n"
        new_orig2 += "\n".join(en_entries) + "\n"
    else:
        new_orig2 += line + "\n"

with open('lib/core/i18n.dart', 'w') as f:
    f.write(new_orig2)
