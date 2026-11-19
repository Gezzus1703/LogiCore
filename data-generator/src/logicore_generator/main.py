from .reference_data import generate_reference_data
from .customers import generate_customers
from .products import generate_products
from .orders import generate_orders
from .order_details import generate_order_details
from .invoices import generate_invoices
from .invoice_lines import generate_invoice_lines
from .payments import generate_payments
from .validation import validate_data


def main():
    print("\nStarting LogiCore data generation...\n")

    print("[1/8] Generating reference data...")
    generate_reference_data()

    print("\n[2/8] Generating customers...")
    generate_customers()

    print("\n[3/8] Generating products...")
    generate_products()

    print("\n[4/8] Generating orders...")
    generate_orders()

    print("\n[5/8] Generating order details...")
    generate_order_details()

    print("\n[6/8] Generating invoices...")
    generate_invoices()

    print("\n[7/8] Generating invoice lines...")
    generate_invoice_lines()

    print("\n[8/8] Generating payments...")
    generate_payments()

    print("\nRunning data validation...")

    if not validate_data():
        raise SystemExit("LogiCore data validation failed.")

    print("\nLogiCore data generation and validation completed successfully.")


if __name__ == "__main__":
    main()