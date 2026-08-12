with open('lib/core/i18n.dart', 'r') as f:
    text = f.read()

text = text.replace("'I'm interested'", "\"I'm interested\"")
text = text.replace("'A bridge between a day's work and the household next door.'", "\"A bridge between a day's work and the household next door.\"")
text = text.replace("'We send a one-time code to confirm it's you.'", "\"We send a one-time code to confirm it's you.\"")

# just in case
text = text.replace("'I\\'m interested'", "\"I'm interested\"")
text = text.replace("'A bridge between a day\\'s work and the household next door.'", "\"A bridge between a day's work and the household next door.\"")
text = text.replace("'We send a one-time code to confirm it\\'s you.'", "\"We send a one-time code to confirm it's you.\"")

with open('lib/core/i18n.dart', 'w') as f:
    f.write(text)
