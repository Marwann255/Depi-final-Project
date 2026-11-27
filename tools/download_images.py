import csv, time
from pathlib import Path
import pandas as pd, requests

ROOT = Path(__file__).resolve().parents[1]
CSV  = ROOT / "assets" / "egyptian-inscriptions.csv"
OUT  = ROOT / "data" / "images"          # outside assets/ so it never ships in the app
OUT.mkdir(parents=True, exist_ok=True)

API = "https://collectionapi.metmuseum.org/public/collection/v1/objects/{}"
H = {"User-Agent": "PharaohLens/0.1 (student project; contact: marwangamal931@gmail.com)"}

def met_id(u): return int(u.rstrip("/").split("/")[-1])

def image_ext(data: bytes):
    if data[:3] == b"\xff\xd8\xff": return "jpg"
    if data[:8] == b"\x89PNG\r\n\x1a\n": return "png"
    return None

df = pd.read_csv(CSV)
manual = []

for r in df.itertuples():
    oid = int(r.id)
    j = requests.get(API.format(met_id(r.source_url)), headers=H, timeout=30).json()
    time.sleep(0.5)
    if not j.get("isPublicDomain"):
        print(oid, "skipped (not public domain)"); continue
    urls = [u for u in [j.get("primaryImage")] + (j.get("additionalImages") or []) if u]
    folder = OUT / str(oid); folder.mkdir(exist_ok=True)
    saved = 0
    for k, u in enumerate(urls):
        manual.append((oid, k, u, r.source_url))
        resp = requests.get(u, headers=H, timeout=60)
        ext = image_ext(resp.content) if resp.status_code == 200 else None
        if ext is None:
            print(oid, "refused:", resp.status_code, "| content-type:", resp.headers.get("content-type"),
                  "| first bytes:", resp.content[:20])
            break                                   # stop, don't hammer
        (folder / f"{k}.{ext}").write_bytes(resp.content); saved += 1
        time.sleep(1)
    print(oid, f"saved {saved}/{len(urls)}")

with open(OUT.parent / "image_urls.csv", "w", newline="", encoding="utf-8") as f:
    csv.writer(f).writerows([("id", "n", "image_url", "object_page"), *manual])
print("Wrote", OUT.parent / "image_urls.csv")