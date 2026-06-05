import urllib.request
import json

url = "https://api.github.com/search/code?q=Apple+Hello+SwiftUI+Path"
req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
try:
    with urllib.request.urlopen(req) as response:
        data = json.loads(response.read())
        if 'items' in data and len(data['items']) > 0:
            for item in data['items'][:3]:
                print(item['html_url'])
        else:
            print("No items found.")
except Exception as e:
    print("Error:", e)
