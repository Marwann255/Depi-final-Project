import csv, webbrowser
from collections import defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
rows = list(csv.DictReader(open(ROOT / "data" / "image_urls.csv", encoding="utf-8")))

by_id = defaultdict(list)
for r in rows:
    by_id[int(r["id"])].append(r["image_url"])

for oid in sorted(by_id):
    folder = ROOT / "data" / "images" / str(oid)
    folder.mkdir(parents=True, exist_ok=True)
    have = len([p for p in folder.iterdir() if p.is_file()])
    todo = by_id[oid][have:]                        # skip ones already saved
    if not todo:
        continue
    print(f"\nObject {oid}: {len(todo)} more image(s) -> {folder}")
    for u in todo:
        webbrowser.open_new_tab(u)
    input("Press Enter when saved (Ctrl+C to stop; rerun later to resume)... ")
    