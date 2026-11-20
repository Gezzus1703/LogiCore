import random

from faker import Faker

from .config import PRODUCTS_COUNT, OUTPUT_DIR, RANDOM_SEED
from .reference_data import CURRENCIES
from .csv_utils import save_to_csv


Faker.seed(RANDOM_SEED)
random.seed(RANDOM_SEED)

fake = Faker("en_US")


# Product name, description, unit, minimum price, maximum price, minimum weight, maximum weight
PRODUCT_CATALOG = [
    ("Wireless Mouse M185", "Wireless optical mouse for everyday office use.", "PCS", 15, 45, 0.07, 0.15),
    ("Mechanical Keyboard K2", "Mechanical keyboard designed for professional use.", "PCS", 150, 450, 0.5, 1.2),
    ("LED Monitor 27 inch", "27-inch LED monitor for office work.", "PCS", 450, 1200, 3.0, 7.0),
    ("USB-C Cable 2m", "Two-meter USB-C charging and data cable.", "PCS", 10, 40, 0.03, 0.12),
    ("Laptop Stand Aluminium", "Adjustable aluminium laptop stand.", "PCS", 50, 180, 0.3, 1.5),
    ("USB Hub 7-Port", "Seven-port USB hub for desktop computers.", "PCS", 35, 120, 0.1, 0.5),
    ("Power Adapter 65W", "Universal 65W power adapter.", "PCS", 40, 150, 0.15, 0.6),
    ("Network Switch 8-Port", "Eight-port gigabit Ethernet switch.", "PCS", 80, 250, 0.3, 1.5),
    ("Barcode Scanner USB", "USB barcode scanner for warehouse operations.", "PCS", 100, 350, 0.2, 0.8),
    ("Laser Printer A4", "Monochrome laser printer for office environments.", "PCS", 400, 1100, 5.0, 15.0),

    ("Office Chair Ergonomic", "Ergonomic office chair with adjustable height.", "PCS", 300, 1200, 10.0, 25.0),
    ("Office Desk 140cm", "Office desk with a durable work surface.", "PCS", 250, 900, 15.0, 40.0),
    ("Desk Lamp LED", "Energy-efficient LED desk lamp.", "PCS", 30, 150, 0.3, 2.0),
    ("Filing Cabinet Metal", "Metal filing cabinet for document storage.", "PCS", 250, 800, 15.0, 50.0),
    ("Whiteboard 120x90cm", "Magnetic whiteboard for meeting rooms.", "PCS", 100, 350, 3.0, 10.0),
    ("Printer Paper A4 500 Sheets", "Standard A4 office printing paper.", "PCS", 12, 35, 2.0, 2.7),
    ("Ballpoint Pen Blue", "Blue ballpoint pen for everyday office use.", "PCS", 1, 5, 0.005, 0.02),
    ("Notebook A5", "A5 ruled notebook with a durable cover.", "PCS", 5, 20, 0.1, 0.4),
    ("Document Folder A4", "Plastic folder for storing office documents.", "PCS", 2, 12, 0.02, 0.15),
    ("Shipping Label Roll", "Thermal labels for shipping and logistics.", "ROLL", 15, 60, None, None),

    ("Cardboard Box Small", "Small corrugated cardboard shipping box.", "PCS", 1, 5, 0.05, 0.3),
    ("Cardboard Box Large", "Large corrugated cardboard shipping box.", "PCS", 4, 15, 0.2, 1.0),
    ("Industrial Storage Box 60L", "Heavy-duty plastic storage container.", "PCS", 15, 60, 1.0, 3.0),
    ("Packing Tape 48mm", "Transparent adhesive packing tape.", "PCS", 2, 8, 0.08, 0.2),
    ("Stretch Film 23um", "Industrial stretch film for pallet wrapping.", "ROLL", 20, 70, None, None),
    ("Bubble Wrap", "Protective bubble wrap for fragile goods.", "M2", 2, 8, None, None),
    ("Pallet Wooden EUR", "Standard EUR wooden transport pallet.", "PCS", 25, 70, 15.0, 25.0),
    ("Plastic Pallet", "Reusable plastic pallet for warehouse operations.", "PCS", 80, 250, 8.0, 20.0),
    ("Protective Foam Sheet", "Protective foam sheet for product packaging.", "M2", 3, 12, None, None),
    ("Plastic Container 20L", "Reusable plastic container with a lid.", "PCS", 8, 30, 0.5, 1.5),

    ("Safety Helmet", "Industrial protective helmet.", "PCS", 20, 90, 0.3, 0.7),
    ("Safety Gloves", "Protective work gloves for industrial applications.", "PAIR", 5, 35, 0.05, 0.3),
    ("Protective Work Jacket", "Durable work jacket for warehouse personnel.", "PCS", 80, 250, 0.5, 1.5),
    ("Safety Boots", "Protective footwear with reinforced toe caps.", "PAIR", 100, 350, 1.0, 2.5),
    ("Safety Glasses", "Protective safety glasses for industrial use.", "PCS", 8, 40, 0.02, 0.1),
    ("Reflective Safety Vest", "High-visibility safety vest.", "PCS", 10, 45, 0.1, 0.3),
    ("First Aid Kit", "Workplace first aid kit.", "PCS", 30, 120, 0.5, 2.0),
    ("Fire Extinguisher 6kg", "Portable powder fire extinguisher.", "PCS", 100, 250, 7.0, 10.0),
    ("Ear Protection", "Industrial hearing protection equipment.", "PCS", 15, 80, 0.1, 0.5),
    ("Dust Mask FFP2", "Disposable FFP2 protective mask.", "PCS", 2, 10, 0.005, 0.03),

    ("Steel Profile 2m", "Steel structural profile for industrial applications.", "M", 8, 35, None, None),
    ("Aluminium Profile 2m", "Aluminium profile for construction and assembly.", "M", 10, 45, None, None),
    ("Copper Wire", "Insulated copper electrical wire.", "M", 2, 15, None, None),
    ("PVC Pipe 50mm", "PVC pipe for industrial installations.", "M", 3, 12, None, None),
    ("Stainless Steel Sheet", "Stainless steel sheet for manufacturing.", "M2", 80, 250, None, None),
    ("Industrial Lubricant", "Lubricant for industrial machinery.", "L", 15, 60, None, None),
    ("Cleaning Liquid 5L", "General-purpose industrial cleaning liquid.", "L", 5, 25, None, None),
    ("Diesel Fuel", "Diesel fuel for industrial equipment.", "L", 1, 3, None, None),
    ("Industrial Sand", "Washed sand for construction applications.", "KG", 0.1, 1, None, None),
    ("Steel Screws", "Steel screws for general assembly work.", "KG", 5, 20, None, None),

    ("Gravel Aggregate", "Gravel aggregate for construction work.", "M3", 30, 100, None, None),
    ("Concrete Mix", "Ready-to-use dry concrete mix.", "KG", 0.3, 1.5, None, None),
    ("Industrial Adhesive", "High-strength adhesive for industrial use.", "KG", 10, 50, None, None),
    ("Warehouse Handling Service", "Warehouse handling and material processing service.", "HOUR", 20, 100, None, None),
    ("Technical Support Service", "Technical support for business equipment.", "HOUR", 40, 150, None, None),
]


def generate_products():
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

    if PRODUCTS_COUNT > len(PRODUCT_CATALOG):
        raise ValueError(
            f"PRODUCTS_COUNT cannot exceed {len(PRODUCT_CATALOG)}."
        )

    currencies = [
        currency["CurrencyCode"]
        for currency in CURRENCIES
    ]

    selected_products = random.sample(
        PRODUCT_CATALOG,
        PRODUCTS_COUNT,
    )

    products = []

    for number, product_data in enumerate(selected_products, start=1):
        (
            name,
            description,
            unit,
            min_price,
            max_price,
            min_weight,
            max_weight,
        ) = product_data

        if min_weight is None:
            net_weight = ""
        else:
            net_weight = f"{random.uniform(min_weight, max_weight):.3f}"

        product = {
            "ProductCode": f"PROD-{number:05d}",
            "ProductName": name,
            "Description": description,
            "UnitOfMeasureCode": unit,
            "UnitPrice": f"{random.uniform(min_price, max_price):.4f}",
            "CurrencyCode": random.choice(currencies),
            "NetWeightKg": net_weight,
            "IsActive": random.choice([1, 1, 1, 1, 1, 1, 1, 1, 1, 0]),
            "CreatedAt": fake.date_time_between(
                start_date="-3y",
                end_date="now",
            ).strftime("%Y-%m-%d %H:%M:%S"),
        }

        products.append(product)

    save_to_csv("products.csv", products)


if __name__ == "__main__":
    generate_products()
