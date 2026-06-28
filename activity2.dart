import 'dart:io';

class Product {
  static const double largeDiscount = 0.1;
  static const double normalDiscount = 0.05;

  final String name;
  final int units;
  final double price;

  Product(this.name, this.units, this.price);

  double get purchase => units*price;

  double get discount
  {
    if (purchase >= 1000000) return purchase*largeDiscount;

    if (purchase >= 500000) return purchase*normalDiscount;

    return 0;
  }

  double get vat => (purchase-discount)*0.08;

  double get finalPurchase => (purchase-discount)+vat;

  @override
  String toString() => '''

== Bill ==
Product: $name
Units: $units
Price/Unit: ${price.toStringAsFixed(2)}

Gross Purchase: ${purchase.toStringAsFixed(2)}
Discount: ${discount.toStringAsFixed(2)}
VAT: ${vat.toStringAsFixed(2)}

Final Purchase: ${finalPurchase.toStringAsFixed(2)}
''';
}

void main() {
  stdout.write("Product: ");
  final String name = stdin.readLineSync() ?? "Unknown";

  stdout.write("Units: ");
  final int units = int.tryParse(stdin.readLineSync() ?? '') ?? 0;

  stdout.write("Price: ");
  final double price = double.tryParse(stdin.readLineSync() ?? '') ?? 0.0;

  print(Product(name, units, price));
}