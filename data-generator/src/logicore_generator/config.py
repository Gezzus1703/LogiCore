from pathlib import Path

# Project directories
PROJECT_ROOT = Path(__file__).resolve().parents[2]
OUTPUT_DIR = PROJECT_ROOT / "output"

# Data volume
CUSTOMERS_COUNT = 100
PRODUCTS_COUNT = 50
ORDERS_COUNT = 500

# Random seed for dupes
RANDOM_SEED = 42