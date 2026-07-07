import 'dart:io';

class Product {

  static final List<Product> _productList = [];

  static List<Product> get productList => List.unmodifiable(_productList);

  static String printProductList() {
    String report = "\n=== Products List ===\n";

    if (_productList.isEmpty) {
      return report + "No products available.";
    }

    for (Product product in _productList) {
      report += '''

$product''';
    }

    return report;
  }

  static bool deleteProduct(Product productToDelete) =>
    _productList.remove(productToDelete);

  static String printTotalPrice() {
    String report = "\n === Total Purchase ===\n";

    if (_productList.isEmpty) {
      return report + "No products available";
    }

    double totalPrice = _productList.fold(0, (totalPrice, p) => totalPrice + p.price*p.units);

    return report + '''
Total items: ${_productList.length}
Total Purchase: $totalPrice
''';
  }

  final String name;
  int _units = 0;
  double _price = 0;

  Product(this.name, int inputUnits, double inputPrice) {
    if (!_isNotDuplicate(name)) {
      throw ArgumentError("Product name already exists (case-insensitive)");
    }

    units = inputUnits;
    price = inputPrice;

    _productList.add(this);
  }

  static bool _isNotDuplicate(String newName) => findByName(newName) == null;
  static bool _isNonNegative(num value) => value >=0;

  set units(int units) {
    if (!_isNonNegative(units)) {
      throw ArgumentError("Units cannot be negative");
    }

    _units = units;
  }

  int get units => _units;

  set price(double price) {
    if (!_isNonNegative(price)) {
      throw ArgumentError("Price cannot be negative");
    }

    _price = price;
  }

  double get price => _price;

  static Product? findByName(String searchName) {
    for (Product product in _productList) {
      if (product.name.toLowerCase() == searchName.toLowerCase()) {
        return product;
      }
    }

    return null;
  }

  String toString() => '''

Name: $name
Units: $units
Price: $price

''';

}


void main() {
  int choice;
  print('''Choose the following choices: 
  (1) Add Product
  (2) Edit/Delete Product 
  (3) Display Products
  (4) Display Total Purchase
  (5) Exit
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
              Product(prodName, prodUnits, prodPrice);

          print("\nProduct successfully added!");
          print(newProduct);
        } on ArgumentError catch (e) {
          print("\nError: ${e.message}");
        }
        break;
      case 2:
        try {
          stdout.write("Product Name: ");
          String deleteName = stdin.readLineSync() ?? "Unknown";

          final product = Product.findByName(deleteName);

          if (product != null) {
            Product.deleteProduct(product);
            print("\nProduct successfully deleted!");
            break;
          }

          print("\nProduct not found!");
        } on ArgumentError catch (e) {
          print("\nError: ${e.message}");
        }
        break;
      case 3:
        try {
          print(Product.printProductList());
        } on ArgumentError catch (e) {
          print("\nError: ${e.message}");
        }
        break;
      case 4: 
        try {
          print(Product.printTotalPrice());
        } on ArgumentError catch (e) {
          print("\nError: ${e.message}");
        }
        break;
      case 5:
        print("Thank You for using!");
        break;
      default:
        print("Invalid option, please choose from 1-5");
    }
  } while (choice != 5);
}