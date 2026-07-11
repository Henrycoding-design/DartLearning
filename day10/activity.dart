import 'dart:io';

class Person {
  String id;
  String name;
  int age;
  String _gender = '';

  static String _normalizeID(String id) {
    return id.trim().toLowerCase();
  }

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

  Person(String id, this.name, this.age, String gender)
      : 
      id = _normalizeID(id),
      _gender = _validateGender(gender);

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

class Classroom {
  final String classID;
  final String className;
  List<Student> _students = [];
  Teacher teacher;

  List<Student> get students => List.unmodifiable(_students);

  Classroom(String id, String className, List<Student> students, Teacher teacher)
  : 
  classID = id,
  className = className,
  teacher = teacher
  {
    _students.addAll(students);
  }

  String addStudent(Student newStudent) {
    if (!_isNotDuplicate(newStudent)) {
      throw ArgumentError.value(newStudent, "New Student", "Student already exists in current class.");
    }

    _students.add(newStudent);
    return "New student ${newStudent.name} added successfully to $className!";
  }

  String addStudents(List<Student> newStudents) {
    for (Student newStudent in newStudents) {
      addStudent(newStudent);
    }

    final studentNames = newStudents.map((stu) => stu.name).join(', ');

    return "New students: ${studentNames} added successfully to $className!";
  }

  bool _isNotDuplicate(Student searchedStudent) {
    for (Student student in _students) {
      if(searchedStudent.id == student.id) {
        return false;
      }
    }

    return true;
  }

  String assignTeacher(Teacher newTeacher) {
    teacher = newTeacher;
    return "Successfully assign ${teacher.name} to class ${className}";
  }

  String printStudents() {
    if (_students.isEmpty) {
      return "No Students enrolled";
    }
    return _students.join('');
  }

  @override
  String toString() => '''

=== Class Info ===
Class name: $className
Class ID: $classID
Teacher: $teacher

Students:${printStudents()}
''';
}


void main() {
  // 1. Manage lists of students, teachers, and classes
  List<Student> students = [
    Student("S01", "Alice Smith", 15, "Woman", 10, 8.5),
    Student("S02", "Bob Jones", 16, "Man", 11, 7.0),
    Student("S03", "Alice Brown", 15, "Woman", 10, 9.2),
    Student("S04", "Charlie Davis", 17, "Man", 12, 6.5),
  ];

  List<Teacher> teachers = [
    Teacher("T01", "Mr. Clark", 40, "Man", "Math", 50000),
    Teacher("T02", "Mrs. Davis", 35, "Woman", "English", 52000),
  ];

  List<Classroom> classrooms = [
    Classroom("C01", "Math 101", [students[0], students[1]], teachers[0]),
  ];

  while (true) {
    print('\n--- School Management Menu ---');
    print('1. Find Student ID by Name');
    print('2. Calculate Student Average Score Across Classes');
    print('3. Create New Classroom');
    print('4. Change Teacher of a Classroom');
    print('5. Add Student(s) to a Classroom');
    print('6. Print Classroom Info');
    print('7. Exit');
    stdout.write('Choose an option (1-7): ');
    
    String? choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        stdout.write('Enter student name to search: ');
        String? searchName = stdin.readLineSync();
        if (searchName != null && searchName.trim().isNotEmpty) {
          String? id = findStudentId(students, searchName);
          if (id != null) {
            print('Found Student ID: $id');
          } else {
            print('No student selected or found.');
          }
        }
        break;

      case '2':
        stdout.write('Enter student name to calculate average: ');
        String? targetName = stdin.readLineSync();
        if (targetName != null && targetName.trim().isNotEmpty) {
          double avg = calculateAverageScore(students, classrooms, targetName);
          if (avg >= 0) {
            print('Average Score across enrolled classes: ${avg.toStringAsFixed(2)}');
          }
        }
        break;

      case '3':
        // 4. Create new classroom: Assign existing teacher and at least 1 existing student
        print('\nAvailable Teachers:');
        for (int i = 0; i < teachers.length; i++) {
          print('$i: ${teachers[i].name} (${teachers[i].subject})');
        }
        stdout.write('Select a teacher index: ');
        int tIndex = int.parse(stdin.readLineSync() ?? '0');

        print('\nAvailable Students:');
        for (int i = 0; i < students.length; i++) {
          print('$i: ${students[i].name}');
        }
        stdout.write('Select a student index to start the class: ');
        int sIndex = int.parse(stdin.readLineSync() ?? '0');

        stdout.write('Enter New Class ID: ');
        String cId = stdin.readLineSync() ?? 'NEW_ID';
        stdout.write('Enter New Class Name: ');
        String cName = stdin.readLineSync() ?? 'NEW_CLASS';

        Classroom newClass = Classroom(cId, cName, [students[sIndex]], teachers[tIndex]);
        classrooms.add(newClass);
        print('Classroom "$cName" created successfully!');
        break;

      case '4':
        // 5. Change teacher of classroom
        if (classrooms.isEmpty) {
          print('No classrooms available.');
          break;
        }
        printClassroomsList(classrooms);
        stdout.write('Select classroom index: ');
        int classIndex = int.parse(stdin.readLineSync() ?? '0');

        print('\nAvailable Teachers:');
        for (int i = 0; i < teachers.length; i++) {
          print('$i: ${teachers[i].name}');
        }
        stdout.write('Select new teacher index: ');
        int teacherIndex = int.parse(stdin.readLineSync() ?? '0');

        String result = classrooms[classIndex].assignTeacher(teachers[teacherIndex]);
        print(result);
        break;

      case '5':
        // 6. Add new student(s) to existing classroom
        if (classrooms.isEmpty) {
          print('No classrooms available.');
          break;
        }
        printClassroomsList(classrooms);
        stdout.write('Select classroom index: ');
        int classIdx = int.parse(stdin.readLineSync() ?? '0');

        print('\nAvailable Students to add:');
        for (int i = 0; i < students.length; i++) {
          print('$i: ${students[i].name} (ID: ${students[i].id})');
        }
        stdout.write('Enter student indices separated by commas (e.g., 2,3): ');
        String? indicesInput = stdin.readLineSync();
        
        if (indicesInput != null && indicesInput.trim().isNotEmpty) {
          List<Student> studentsToAdd = [];
          try {
            var indices = indicesInput.split(',').map((e) => int.parse(e.trim()));
            for (var idx in indices) {
              studentsToAdd.add(students[idx]);
            }
            // Uses addStudents implementation
            String msg = classrooms[classIdx].addStudents(studentsToAdd);
            print(msg);
          } catch (e) {
            print('Error adding students: ${e.toString()}');
          }
        }
        break;

      case '6':
        // 7. Print class info
        if (classrooms.isEmpty) {
          print('No classrooms available.');
          break;
        }
        printClassroomsList(classrooms);
        stdout.write('Select classroom index to inspect: ');
        int viewIdx = int.parse(stdin.readLineSync() ?? '0');
        
        // toString handles the formatting as requested
        print(classrooms[viewIdx]); 
        break;

      case '7':
        print('Exiting Program...');
        return;

      default:
        print('Invalid option. Please try again.');
    }
  }
}

/// Helper to display classrooms
void printClassroomsList(List<Classroom> classrooms) {
  print('\nAvailable Classrooms:');
  for (int i = 0; i < classrooms.length; i++) {
    print('$i: ${classrooms[i].className} (ID: ${classrooms[i].classID})');
  }
}

/// 2. Find student name function
String? findStudentId(List<Student> students, String searchName) {
  List<Student> matches = students
      .where((s) => s.name.toLowerCase().contains(searchName.toLowerCase()))
      .toList();

  if (matches.isEmpty) {
    print('No student found matching "$searchName".');
    return null;
  }

  if (matches.length == 1) {
    return matches.first.id;
  }

  // Multiple students identified
  print('\nMultiple students found. Please select one:');
  for (int i = 0; i < matches.length; i++) {
    print('$i: ID: ${matches[i].id} | Name: ${matches[i].name} | Grade: ${matches[i].grade}');
  }
  
  stdout.write('Enter choice index: ');
  int selection = int.tryParse(stdin.readLineSync() ?? '0') ?? -1;
  
  if (selection >= 0 && selection < matches.length) {
    return matches[selection].id;
  } else {
    print('Invalid selection.');
    return null;
  }
}

/// 3. Calculate average scores of students function
double calculateAverageScore(List<Student> students, List<Classroom> classrooms, String searchName) {
  // Step 2 functionality call inside
  String? targetId = findStudentId(students, searchName);
  if (targetId == null) return -1;

  double totalScore = 0.0;
  int classCount = 0;

  for (var classroom in classrooms) {
    // Look through students collection
    for (var student in classroom.students) {
      if (student.id == targetId) {
        totalScore += student.score;
        classCount++;
        break; // Match found in this specific class, skip to next classroom
      }
    }
  }

  if (classCount == 0) {
    print('Student with ID $targetId is not enrolled in any classrooms.');
    return 0.0;
  }

  return totalScore / classCount;
}