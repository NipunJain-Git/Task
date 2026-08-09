import re
with open('lib/core/i18n.dart', 'r') as f:
    text = f.read()

# convert \' to '
text = text.replace("\\'", "'")
# now replace '...': '...' with "..." : "..." safely using regex
# actually, just let python exec it as a dict and write JSON? No, it has dart syntax.
# Instead of doing that, let's just find lines with 'We send a one-time code to confirm it's you.'
# and fix them.

lines = []
for line in text.split('\n'):
    if "one-time code" in line:
        line = '    "We send a one-time code to confirm it\'s you.": "We send a one-time code to confirm it\'s you.",'
    lines.append(line)

with open('lib/core/i18n.dart', 'w') as f:
    f.write('\n'.join(lines))
