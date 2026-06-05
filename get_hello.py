import urllib.request
import re

svg_url = "https://upload.wikimedia.org/wikipedia/commons/e/ec/Hello_MacOS.svg"
req = urllib.request.Request(svg_url, headers={'User-Agent': 'Mozilla/5.0'})
try:
    with urllib.request.urlopen(req) as response:
        svg_data = response.read().decode('utf-8')
        print(svg_data)
except Exception as e:
    print("Error:", e)
