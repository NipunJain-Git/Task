import json
import re

with open('jobs_i18n.json', 'r') as f:
    jobs = json.load(f)

with open('lib/core/i18n.dart', 'r') as f:
    content = f.read()

for lang in ['en', 'hi', 'mr', 'gu', 'bn']:
    # Find the language block
    pattern = r"('" + lang + r"': \{)([\s\S]*?)(\n  \},)"
    match = re.search(pattern, content)
    if match:
        existing = match.group(2)
        new_entries = []
        for k, v in jobs[lang].items():
            # escape single quotes
            k_escaped = k.replace("'", "\\'")
            v_escaped = v.replace("'", "\\'")
            new_entries.append(f"    '{k_escaped}': '{v_escaped}',")
        
        replacement = match.group(1) + existing + "\n" + "\n".join(new_entries) + match.group(3)
        content = content.replace(match.group(0), replacement)

with open('lib/core/i18n.dart', 'w') as f:
    f.write(content)

