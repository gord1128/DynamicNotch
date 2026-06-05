import json
import time
from deep_translator import GoogleTranslator

file_path = 'DynamicNotch/Resources/Localization/Localizable.xcstrings'

with open(file_path, 'r', encoding='utf-8') as f:
    data = json.load(f)

translator = GoogleTranslator(source='en', target='ko')

strings = data.get('strings', {})
total = len(strings)
print(f"Total keys to process: {total}", flush=True)

# Collect all keys that need translation
keys_to_translate = []
texts_to_translate = []

for key, item in strings.items():
    localizations = item.get('localizations', {})
    
    if 'ko' in localizations:
        continue
        
    text = key
    if 'en' in localizations and 'stringUnit' in localizations['en']:
        text = localizations['en']['stringUnit'].get('value', key)
        
    if len(text.strip()) == 0 or text in ['-', '--', '---', '%@%%', '%lld', '%lld%%', '•']:
        # Instantly apply trivial ones
        localizations['ko'] = {'stringUnit': {'state': 'translated', 'value': text}}
        item['localizations'] = localizations
    else:
        keys_to_translate.append(key)
        texts_to_translate.append(text)

print(f"Need to translate {len(texts_to_translate)} items...", flush=True)

batch_size = 50
for i in range(0, len(texts_to_translate), batch_size):
    batch_texts = texts_to_translate[i:i+batch_size]
    batch_keys = keys_to_translate[i:i+batch_size]
    
    try:
        translated_batch = translator.translate_batch(batch_texts)
        for j, translated_text in enumerate(translated_batch):
            k = batch_keys[j]
            item = strings[k]
            loc = item.get('localizations', {})
            loc['ko'] = {'stringUnit': {'state': 'translated', 'value': translated_text or batch_texts[j]}}
            item['localizations'] = loc
            
        print(f"Translated batch {i//batch_size + 1}/{(len(texts_to_translate)-1)//batch_size + 1}", flush=True)
    except Exception as e:
        print(f"Error translating batch: {e}", flush=True)
        # fallback to individual
        for j, text in enumerate(batch_texts):
            try:
                t = translator.translate(text)
                loc = strings[batch_keys[j]].get('localizations', {})
                loc['ko'] = {'stringUnit': {'state': 'translated', 'value': t}}
                strings[batch_keys[j]]['localizations'] = loc
            except Exception as e2:
                print(f"Individual error on '{text}': {e2}")
    
    with open(file_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
        
print("Translation complete!", flush=True)
