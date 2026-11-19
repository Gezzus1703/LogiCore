import csv

from .config import OUTPUT_DIR


def save_to_csv(filename, rows):
    if not rows:
        raise ValueError(f"Cannot generate {filename}: there are no rows to write.")

    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    file_path = OUTPUT_DIR / filename

    with file_path.open("w", newline="", encoding="utf-8-sig") as csv_file:
        writer = csv.DictWriter(csv_file, fieldnames=rows[0].keys())
        writer.writeheader()
        writer.writerows(rows)

    print(f"Generated {filename}: {len(rows)} rows")
