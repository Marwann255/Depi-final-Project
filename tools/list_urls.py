import csv, time
from pathlib import Path
import pandas as pd, requests

ROOT = Path(__file__).resolve().parents[1]
df = pd.read_csv(ROOT / "assets" / "egyptian-inscriptions.csv")
API = "https://collectionapi.metmuseum.org/public/collection/v1/objects/{}"
H = {"User-Agent": "PharaohLens/0.1 (student project; contact: YOUR-EMAIL@example.com)"}

def met_id(u): return int(u.rstrip("/").split("/")[-1])

rows = []
for r in df.itertuples():
    j = requests.get(API.format(met_id(r.source_url)), headers=H, timeout=30).json()
    time.sleep(0.5)
    if not j.get("isPublicDomain"):
        continue
    urls = [u for u in [j.get("primaryImage")] + (j.get("additionalImages") or []) if u]
    for k, u in enumerate(urls):
        rows.append((int(r.id), k, u, r.source_url))
    print(r.id, len(urls), "urls")

out = ROOT / "data" / "image_urls.csv"
with open(out, "w", newline="", encoding="utf-8") as f:
    csv.writer(f).writerows([("id", "n", "image_url", "object_page"), *rows])
print("Total:", len(rows), "->", out)