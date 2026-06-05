import os
import re

def replacer(match):
    # Match: .font(.system(XXX)).weight(.YYY)
    # Group 1: XXX
    # Group 2: YYY
    system_args = match.group(1)
    weight = match.group(2)
    return f".font(.system({system_args}).weight(.{weight}))"

def refactor_file(filepath):
    with open(filepath, 'r') as f:
        content = f.read()
        
    # Match .font(.system(...)).weight(.XXX)
    new_content = re.sub(r'\.font\(\.system\(([^)]+)\)\)\.weight\(\.([a-zA-Z0-9_]+)\)', replacer, content)
    
    if new_content != content:
        with open(filepath, 'w') as f:
            f.write(new_content)
        print(f"Fixed: {filepath}")

for root, dirs, files in os.walk('.'):
    for file in files:
        if file.endswith('.swift'):
            refactor_file(os.path.join(root, file))
