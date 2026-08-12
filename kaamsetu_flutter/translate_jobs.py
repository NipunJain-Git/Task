import json
from googletrans import Translator

translator = Translator()
strings = [
    'Deep clean 2BHK apartment',
    'Full house deep cleaning including kitchen and bathrooms. Tools will be provided.',
    'Paint two rooms (walls only)',
    'Two bedrooms need fresh paint. Paint and brushes available.',
    'Fix leaking tap and check pipes',
    'Shifting furniture — 2BHK to 3BHK',
    'Moving from Kothrud to Baner. Ground floor to 3rd floor. Elevator available.',
    'Garden cleanup and trimming'
]
langs = ['hi', 'mr', 'gu', 'bn']

translations = { 'en': {s: s for s in strings} }
for l in langs:
    translations[l] = {}
    for s in strings:
        try:
            translations[l][s] = translator.translate(s, dest=l).text
        except:
            translations[l][s] = s

print(json.dumps(translations, ensure_ascii=False, indent=2))
