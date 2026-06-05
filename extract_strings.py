import json
import os

def main():
    xcstrings_path = 'DynamicNotch/Resources/Localization/Localizable.xcstrings'
    if not os.path.exists(xcstrings_path):
        print("Localizable.xcstrings not found.")
        return

    with open(xcstrings_path, 'r', encoding='utf-8') as f:
        data = json.load(f)

    langs = ['ko', 'en', 'es', 'ru', 'zh-Hans']
    for lang in langs:
        lproj_dir = f'build/DynamicNotch.app/Contents/Resources/{lang}.lproj'
        os.makedirs(lproj_dir, exist_ok=True)
        
        out_lines = []
        for key, value in data.get('strings', {}).items():
            locs = value.get('localizations', {})
            if lang in locs:
                val = locs[lang].get('stringUnit', {}).get('value', '')
                val = (val or "").replace('"', '\\"').replace('\n', '\\n')
                key_escaped = key.replace('"', '\\"').replace('\n', '\\n')
                out_lines.append(f'"{key_escaped}" = "{val}";\n')
            elif lang == 'en':
                # For English, the default is the key if it's missing in 'localizations'
                key_escaped = key.replace('"', '\\"').replace('\n', '\\n')
                out_lines.append(f'"{key_escaped}" = "{key_escaped}";\n')
                
        with open(f'{lproj_dir}/Localizable.strings', 'w', encoding='utf-8') as f:
            f.writelines(out_lines)

    print("✅ Generated .strings files for App Bundle.")

if __name__ == '__main__':
    main()
