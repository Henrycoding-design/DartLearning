class BankAccount {
  // Static validation helpers (called before variables are assigned)
  static bool _isNonNegative(num value) => value >= 0;

  static int _validateAccountNumber(int value) {
    if (!_isNonNegative(value)) {
      throw ArgumentError.value(value, 'accountNumber', 'Account number cannot be negative.');
    }
    return value;
  }

  static double _validateBalance(double value) {
    if (!_isNonNegative(value)) {
      throw ArgumentError.value(value, 'balance', 'Balance cannot be negative.');
    }
    return value;
  }

  int _accountNumber;
  final String ownerName;
  double _balance;

  // Constructor with named, required parameters and pre-assignment validation
  BankAccount({
    required int accountNumber,
    required this.ownerName,
    required double balance,
  })  : _accountNumber = _validateAccountNumber(accountNumber),
        _balance = _validateBalance(balance);

  // Getters and Setters
  int get accountNumber => _accountNumber;
  set accountNumber(int value) {
    _accountNumber = _validateAccountNumber(value);
  }

  double get balance => _balance;
  set balance(double value) {
    _balance = _validateBalance(value);
  }

  @override
  String toString() => '''
== Account Info ==
Account Number: $_accountNumber
Owner Name: $ownerName
Balance: \$$_balance
===
''';
}

// Global functions remain clean and simple
void withdraw(BankAccount acc, double amount) {
  if (amount < 0) throw ArgumentError("Invalid withdraw amount.");
  try {
    acc.balance -= amount;
    print("Withdraw balance amount $amount from ${acc.accountNumber} successfully.");
  } on ArgumentError catch (e) {
    print("Withdraw error: Insufficient funds or invalid amount. (${e.message})");
    return;
  }
}

void addDeposit(BankAccount acc, double amount) {
  if (amount < 0) throw ArgumentError("Invalid deposit amount.");
  acc.balance += amount; 
  print("Added balance amount $amount to ${acc.accountNumber} successfully.");
}

void main() {
  // Creating the account using named parameters!
  var acc = BankAccount(
    accountNumber: 1234, 
    ownerName: "ABC", 
    balance: 100.0,
  );

  print(acc);

  withdraw(acc, 50);
  print(acc);

  // This will fail immediately during creation, preventing "bad" objects from existing
  try {
    var badAcc = BankAccount(
      accountNumber: -999, 
      ownerName: "Bad Guy", 
      balance: -10.0,
    );
    print(badAcc);
  } catch (e) {
    print("Caught expected creation error: $e");
  }
}