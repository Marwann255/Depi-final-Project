import html
from urllib.parse import quote
from pathlib import Path
import pandas as pd

ROOT = Path(__file__).resolve().parents[1]
df = pd.read_csv(ROOT / "assets" / "egyptian-inscriptions.csv")
IMG = ROOT / "data" / "images"
EXT = {".jpg", ".jpeg", ".png", ".webp"}

parts = ["<html><body style='font-family:sans-serif'>"]
for r in df.itertuples():
    oid, n = int(r.id), int(r.images)
    if n == 0:
        continue
    files = sorted(p for p in (IMG / str(oid)).glob("*") if p.suffix.lower() in EXT)
    status = "OK" if len(files) == n else f"MISMATCH (have {len(files)}, expected {n})"
    print(oid, r.title, "|", status)
    parts.append(f"<h2>{oid}: {html.escape(r.title)} - {status}</h2>")
    for p in files:
        parts.append(f"<img src='images/{oid}/{quote(p.name)}' style='height:160px;margin:4px'>")
(ROOT / "data" / "review.html").write_text("".join(parts), encoding="utf-8")
print("Open data\\review.html in your browser")