import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'student.dart';
import 'course.dart' as course_lib;

class RegisterCoursesPage extends StatefulWidget {
  final Student student;

  RegisterCoursesPage({required this.student});

  @override
  _RegisterCoursesPageState createState() => _RegisterCoursesPageState();
}

class _RegisterCoursesPageState extends State<RegisterCoursesPage> {
  List<course_lib.Course> availableCourses = [];
  Map<int, bool> selectedCourses = {};

  @override
  void initState() {
    super.initState();
    fetchAvailableCourses();
    initializeSelectedCourses();
  }

  void initializeSelectedCourses() {
    for (var course in widget.student.courses) {
      selectedCourses[course.id] = true;
    }
  }

  Future<void> fetchAvailableCourses() async {
    final response = await http.get(Uri.parse('https://62030137.000webhostapp.com/get_all_courses.php'));
    if (response.statusCode == 200) {
      List<dynamic> courseJson = json.decode(response.body);
      setState(() {
        availableCourses = courseJson.map((json) => course_lib.Course.fromJson(json)).toList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load courses')),
      );
    }
  }

  void updateCourseRegistration() async {

    final updateData = {
      'studentId': widget.student.id.toString(),
      'courses': selectedCourses.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key.toString())
          .toList(),
    };

    final response = await http.post(
      Uri.parse('https://62030137.000webhostapp.com/update_student_courses.php'),
      body: json.encode(updateData),
    );

    if (response.statusCode == 200) {
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update courses')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register Courses'),
        backgroundColor: Colors.teal[400],
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: updateCourseRegistration,
          ),
        ],
      ),
      body: availableCourses.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: availableCourses.length,
        itemBuilder: (context, index) {
          course_lib.Course course = availableCourses[index];
          bool isSelected = selectedCourses[course.id] ?? false;

          return ListTile(
            title: Text(course.name),
            subtitle: Text('${course.creditHours} Credit Hours'),
            trailing: Checkbox(
              value: isSelected,
              onChanged: (bool? newValue) {
                setState(() {
                  selectedCourses[course.id] = newValue!;
                });
              },
            ),
          );
        },
      ),
    );
  }
}
