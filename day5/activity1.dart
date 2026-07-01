import 'dart:io';

class Employee {
  static const double overtimeBonus = 1.2;
  static const double highTax = 0.10;
  static const double normalTax = 0.05;


  final String name;
  final double workHours;
  final double salaryPerHour;

  Employee(this.name, this.workHours, this.salaryPerHour);


  double get totalSalary => 
      (workHours >= 40) ? 
        workHours*salaryPerHour*overtimeBonus
        : workHours*salaryPerHour;
  

  double get tax {
    final double salary = totalSalary;

    if (salary > 10000000) return salary*highTax;
    if (salary >= 7000000) return salary*normalTax;

    return 0;
  }

  double get finalSalary => totalSalary - tax;

  @override
  String toString() => '''

== INFO ==
Employee name: $name
Gross Salary: ${totalSalary.toStringAsFixed(2)}
Tax: ${tax.toStringAsFixed(2)}
Final Salary: ${finalSalary.toStringAsFixed(2)}
====
    ''';
  

}

void main() {
  bool next = true;

  do {
    stdout.write("Employee name: ");
    final String name = stdin.readLineSync() ?? 'Unknown';

    stdout.write("Work Hours: ");
    final double workHours = double.tryParse(stdin.readLineSync() ?? '0') ?? 0;

    stdout.write("Salary per Hour: ");
    final double salaryPerHour = double.tryParse(stdin.readLineSync() ?? '0') ?? 0;

    print(Employee(name, workHours, salaryPerHour));

    stdout.write("Next? (y/n): ");
    next = (stdin.readLineSync() ?? '').trim().toLowerCase() == 'y';
  } while (next);
}