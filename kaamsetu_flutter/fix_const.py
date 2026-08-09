import re
def remove_const(path):
    with open(path, 'r') as f: text = f.read()
    text = re.sub(r'const AppUser\(', r'AppUser(', text)
    text = re.sub(r'const NearbyWorker\(', r'NearbyWorker(', text)
    with open(path, 'w') as f: f.write(text)

remove_const('lib/data/models.dart')
remove_const('lib/data/seed.dart')
