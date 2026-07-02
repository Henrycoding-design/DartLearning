import 'dart:io';

class Product {

  static String get printProductsList {
    if (_products.isEmpty) {
      return "\n=== Products List ===\nNo products available.";
    }

    String report = "\n=== Products List ===";

    for (final product in _products) {
      report += '''

$product''';
    }

    return report;
  }

  static final List<Product> _products = [];

  static List<Product> get products => List.unmodifiable(_products);

  final String name;
  double _price = 0;
  int _units = 0;

  Product(this.name, double inputPrice, int inputUnits) {

    if (!_isNotDuplicate(name)) {
      throw ArgumentError("Product name already exists (case-insensitive)");
    }

    price = inputPrice;

    units = inputUnits;

    _products.add(this);
  }

  static bool _isNonNegative(num param) => param >= 0;
  static bool _isNotDuplicate(String name) => 
    findByName(name) == null;


  set price(double newPrice) {
    if (!_isNonNegative(newPrice)) throw ArgumentError("Price cannot be negative");

    _price = newPrice;
  }

  double get price => _price;

  set units(int newUnits) {
    if (!_isNonNegative(newUnits)) throw ArgumentError("Units cannot be negative");

    _units = newUnits;
  }

  int get units => _units;
  

  static Product? findByName(String name) {
    for (final product in products) {
      if (product.name.toLowerCase() == name.toLowerCase()) {
        return product;
      }
    }

    return null;
  }

  static Product updateSales(String prodName, int unitsSold) {
    Product? product = findByName(prodName);

    if (product == null) 
      throw ArgumentError.value(prodName, "Product Name", "No Product Name found");

    if (!_isNonNegative(unitsSold)) {
      throw ArgumentError.value(
        unitsSold,
        "Units Sold",
        "Units sold cannot be negative",
      );
    }

    if (product.units < unitsSold) 
      throw ArgumentError.value(unitsSold, "Units Sold", "Not enough units in stock");

    product.units -= unitsSold;

    return product;
  }

  @override
  String toString() => '''

=== Product Info ===
Product Name: ${name}
Price per unit: ${price.toStringAsFixed(2)}
Units: $units
''';

}

void main() {
  int choice;

  print('''

========== Product Management ==========
1. Add Product
2. View All Products
3. Find Product
4. Update Sales
5. Exit
========================================
''');
  do {
    stdout.write("Enter your choice: ");
    choice = int.tryParse(stdin.readLineSync() ?? '') ?? 0;

    switch (choice) {
      case 1:
        try {
          stdout.write("Product Name: ");
          String prodName = stdin.readLineSync() ?? "Unknown";

          stdout.write("Product Price: ");
          double prodPrice =
              double.tryParse(stdin.readLineSync() ?? '') ?? 0.0;

          stdout.write("Product Units: ");
          int prodUnits =
              int.tryParse(stdin.readLineSync() ?? '') ?? 0;

          Product newProduct =
              Product(prodName, prodPrice, prodUnits);

          print("\nProduct successfully added!");
          print(newProduct);
        } on ArgumentError catch (e) {
          print("\nError: ${e.message}");
        }
        break;

      case 2:
        print(Product.printProductsList);
        break;

      case 3:
        stdout.write("Enter product name: ");
        String name = stdin.readLineSync() ?? "";

        Product? product = Product.findByName(name);

        if (product == null) {
          print("Product not found.");
        } else {
          print(product);
        }
        break;

      case 4:
        try {
          stdout.write("Product Name: ");
          String name = stdin.readLineSync() ?? "";

          stdout.write("Units Sold: ");
          int sold = int.tryParse(stdin.readLineSync() ?? '') ?? 0;

          Product updated =
              Product.updateSales(name, sold);

          print("\nSales updated successfully!");
          print(updated);
        } on ArgumentError catch (e) {
          print("\nError: ${e.message}");
        }
        break;

      case 5:
        print("Thank you for using Product Management!");
        break;

      default:
        print("Invalid option. Please choose from 1-5.");
    }
  } while (choice != 5);
}