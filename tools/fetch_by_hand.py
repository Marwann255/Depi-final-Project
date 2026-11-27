import csv, shutil, sys, webbrowser
from collections import defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DL = Path.home() / "Downloads"
EXT = {".jpg", ".jpeg", ".png", ".webp"}

by_id = defaultdict(list)
for r in csv.DictReader(open(ROOT / "data" / "image_urls.csv", encoding="utf-8")):
    by_id[int(r["id"])].append(r["image_url"])

ids = [int(a) for a in sys.argv[1:]]
if not ids:
    sys.exit("Usage: python tools\\fetch_by_hand.py 15 21 22 ...")

for oid in ids:
    folder = ROOT / "data" / "images" / str(oid)
    folder.mkdir(parents=True, exist_ok=True)
    before = {p.name for p in DL.iterdir()}
    expected = len(by_id[oid])
    print(f"\nObject {oid}: save {expected} image(s) into your Downloads folder")
    for u in by_id[oid]:
        webbrowser.open_new_tab(u)
    input("Press Enter when all are saved... ")
    new = [p for p in DL.iterdir() if p.name not in before and p.suffix.lower() in EXT]
    start = len(list(folder.iterdir()))
    for k, p in enumerate(sorted(new, key=lambda p: p.stat().st_mtime), start=start):
        shutil.move(str(p), str(folder / f"{k}{p.suffix.lower()}"))
    print(f"  moved {len(new)} (expected {expected})", "OK" if len(new) == expected else "<-- CHECK")