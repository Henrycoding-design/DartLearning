import 'dart:io';
import 'dart:math';

class Student {
  static const int subjectNum = 3;

  static List<Student> scoreboard = [];
  static double get maxScore => scoreboard.isEmpty ? 0 : scoreboard.map((e)=>e.avgScore).reduce(max);
  static List<Student> get bestStudents {
    double highest = maxScore;

    return scoreboard
      .where((e) => e.avgScore == highest)
      .toList();
  }

  static String get report {
    var best = bestStudents;
    String report = '''

=== Students List ===
''';
    for (var student in scoreboard) {
      report += '''

Name: ${student.name}
Avg. Score: ${student.avgScore}
Letter Score: ${student.letterScore}

''';
    }

    report += '''

=== Best Students ===
Best Avg. Score: ${maxScore}
Best Letter Score: ${best.isEmpty ? "N/A" : best.first.letterScore}
''';

    for (var student in best) {
      report += '''

Name: ${student.name}
''';
    }

    return report;
  }

  final String name;
  final double mathScore;
  final double phyScore;
  final double chemScore;

  Student(this.name, this.mathScore, this.phyScore, this.chemScore) {
    if (
      !_isValidScore(mathScore) ||
      !_isValidScore(phyScore) ||
      !_isValidScore(chemScore)
    ) {
      throw ArgumentError("All scores must be between 0 and 10.");
    }
    scoreboard.add(this);
  }

  static bool _isValidScore(double score) => 0 <= score && score <= 10;

  double get avgScore => (mathScore + phyScore + chemScore)/subjectNum;

  String get letterScore {
    double avgScoreCache = avgScore;
    if (avgScoreCache < 5.0) return "Needs Improvement";
    if (5.0 <= avgScoreCache && avgScoreCache< 7.0) return "Good";
    if (7.0 <= avgScoreCache && avgScoreCache < 9.0) return "Very Good";
    if (avgScoreCache <= 10) return "Excellent";
    return "Invalid";
  }

  @override
  String toString() => '''
Name: $name
Avg. Score: $avgScore
Letter Score: $letterScore
''';

}

void main() {
  bool next = true;
  bool display = true;
  do {
    stdout.write("Student Name: ");
    String name = stdin.readLineSync() ?? "Unknown";

    stdout.write("Math score: ");
    double mathScore = double.tryParse(stdin.readLineSync() ?? '') ?? 0;

    stdout.write("Physics score: ");
    double phyScore = double.tryParse(stdin.readLineSync() ?? '') ?? 0;

    stdout.write("Chemistry score: ");
    double chemScore = double.tryParse(stdin.readLineSync() ?? '') ?? 0;

    try {
    Student(name, mathScore, phyScore, chemScore);
    } on ArgumentError catch (e) {
      print(e.message);
      continue;
    }

    stdout.write("Display result? (y/n): ");
    display = (stdin.readLineSync() ?? '').trim().toLowerCase() == 'y';

    if (display) 
      print(Student.report);


    stdout.write("Continue? (y/n): ");
    next = (stdin.readLineSync() ?? '').trim().toLowerCase() == 'y';
  } while (next);
}