import os
import re

def size_to_style(size):
    if size < 12: return ".caption2"
    if size == 12: return ".caption"
    if size == 13: return ".footnote"
    if size == 14: return ".subheadline"
    if size <= 16: return ".callout"
    if size <= 18: return ".title3"
    if size <= 22: return ".title2"
    if size <= 28: return ".title"
    return ".largeTitle"

def replacer(match):
    # Match string: .font(.system(size: 16, weight: .semibold, design: .rounded))
    # Or: .font(.system(size: 12))
    # We will use regex to parse the arguments
    content = match.group(1)
    
    size_match = re.search(r'size:\s*([0-9.]+)', content)
    weight_match = re.search(r'weight:\s*\.([a-zA-Z0-9]+)', content)
    design_match = re.search(r'design:\s*\.([a-zA-Z0-9]+)', content)
    
    if not size_match:
        return match.group(0)
        
    size = float(size_match.group(1))
    style = size_to_style(size)
    
    # Reconstruct
    args = [style]
    if design_match:
        args.append(f"design: .{design_match.group(1)}")
        
    result = f".font(.system({', '.join(args)}))"
    
    if weight_match:
        weight = weight_match.group(1)
        # .headline and .subheadline already have default weights, but we can just apply .weight()
        # except that SwiftUI Font doesn't have .weight modifier directly unless it's a View modifier or applied to Font.
        # Actually `Font.system(.headline).weight(.semibold)` is valid!
        result += f".weight(.{weight})"
        
    return result

def refactor_file(filepath):
    with open(filepath, 'r') as f:
        content = f.read()
        
    # Match .font(.system( ... ))
    # Note: this simple regex assumes balanced parentheses. Since we know the codebase, it's mostly flat.
    new_content = re.sub(r'\.font\(\.system\(([^)]+)\)\)', replacer, content)
    
    if new_content != content:
        with open(filepath, 'w') as f:
            f.write(new_content)
        print(f"Refactored: {filepath}")

for root, dirs, files in os.walk('.'):
    for file in files:
        if file.endswith('.swift'):
            refactor_file(os.path.join(root, file))
