import json
import time
from deep_translator import GoogleTranslator

file_path = 'DynamicNotch/Resources/Localization/Localizable.xcstrings'

with open(file_path, 'r', encoding='utf-8') as f:
    data = json.load(f)

translator = GoogleTranslator(source='auto', target='ko')

strings = data.get('strings', {})
total = len(strings)
print(f"Total keys to process: {total}")

count = 0
for key, item in strings.items():
    localizations = item.get('localizations', {})
    
    # If Korean already exists, skip
    if 'ko' in localizations:
        continue
    
    # Determine what to translate
    # Try to get English value first
    text_to_translate = key
    if 'en' in localizations and 'stringUnit' in localizations['en']:
        text_to_translate = localizations['en']['stringUnit'].get('value', key)
        
    # Skip empty or short symbol keys
    if len(text_to_translate.strip()) == 0 or text_to_translate in ['-', '--', '---', '%@%%', '%lld', '%lld%%', '•']:
        ko_text = text_to_translate
    else:
        try:
            ko_text = translator.translate(text_to_translate)
        except Exception as e:
            print(f"Error translating '{text_to_translate}': {e}")
            ko_text = text_to_translate
            time.sleep(1) # Backoff
            
    # Add ko localization
    localizations['ko'] = {
        'stringUnit': {
            'state': 'translated',
            'value': ko_text
        }
    }
    
    item['localizations'] = localizations
    
    count += 1
    if count % 50 == 0:
        print(f"Translated {count}/{total}...")
        
        # Save progress
        with open(file_path, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)

# Final save
with open(file_path, 'w', encoding='utf-8') as f:
    json.dump(data, f, ensure_ascii=False, indent=2)

print("Translation complete!")
