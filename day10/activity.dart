class Person {
  String id;
  String name;
  int age;
  String _gender = '';

  static String _validateGender(String gender) {
    if (gender != "Man" && gender != "Woman") {
      throw ArgumentError.value(
        gender,
        "gender",
        "Gender can only be 'Man' or 'Woman'.",
      );
    }
    return gender;
  }

  Person(this.id, this.name, this.age, String gender)
      : _gender = _validateGender(gender);

  String get gender => _gender;
  set gender(String gender) {
    _gender = _validateGender(gender);
  }
}

bool _isNonNegative(num value) => value >= 0;

class Student extends Person {
  static int _validateGrade(int grade) {
    if (!_isNonNegative(grade) || grade > 12) {
      throw ArgumentError.value(grade, "Grade", "Grade must me >= 0 and <= 12.");
    }
    return grade;
  }
  static double _validateScore(double score) { 
    if (!_isNonNegative(score) || score > 10) {
      throw ArgumentError.value(score, "Score", "Score must me >= 0 and <= 10.");
    }
    return score;
  }
  
  int _grade;
  double _score;

  Student(String id, String name, int age, String gender, 
  int grade, double score)
  : 
  _grade = _validateGrade(grade),
  _score = _validateScore(score),
  super(id, name, age, gender);

  set grade(int grade) {
    _grade = _validateGrade(grade);
  }
  int get grade => _grade;

  set score(double score) {
    _score = _validateScore(score);
  }
  double get score => _score;

  @override
  String toString() => '''

=== Student Info ===
Name: ${super.name}
ID: ${super.id}
Grade: $grade (${super.age} years-old)
Gender: ${super.gender}

Score: $score
''';
}

class Teacher extends Person {
  final String subject;
  double _salary;

  static double _validateSalary(double salary) {
    if (!_isNonNegative(salary)) {
      throw ArgumentError.value(salary, "Salary", "Salary must not be negative.");
    }
    return salary;
  }

  Teacher(String id, String name, int age, String gender, 
  String subject, double salary)
  : 
  subject = subject,
  _salary = _validateSalary(salary),
  super(id, name, age, gender);

  set salary(double salary) {
    _salary = _validateSalary(salary);
  }
  double get salary => _salary;

  @override
  String toString() => '''

=== Teacher Info ===
Name: ${super.name}
ID: ${super.id}
Age: ${super.age}
Gender: ${super.gender}

Subject: $subject
Salary: $salary
''';
}