import 'course.dart';

class Student {
  final int id;
  final String name;
  final String email;
  final double gpa;
  final String currentSemester;
  final String avatarPath;
  final List<Course> courses;

  Student({
    required this.id,
    required this.name,
    required this.email,
    required this.gpa,
    required this.currentSemester,
    required this.avatarPath,
    required this.courses,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    var list = json['courses'] as List? ?? [];
    List<Course> coursesList = list.map((i) => Course.fromJson(i)).toList();

    return Student(
      id: int.parse(json['id']),
      name: json['name'],
      email: json['email'],
      gpa: double.parse(json['gpa']),
      currentSemester: json['currentSemester'],
      avatarPath: json['avatarPath'],
      courses: coursesList,
    );
  }
}

class Course {
  final int id;
  final String name;
  final int creditHours;

  Course({
    required this.id,
    required this.name,
    required this.creditHours,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: int.parse(json['id']),
      name: json['name'],
      creditHours: int.parse(json['creditHours']),
    );
  }
}
