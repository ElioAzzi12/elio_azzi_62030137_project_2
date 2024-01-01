import 'package:flutter/material.dart';
import 'student.dart';

class StudentDetailPage extends StatelessWidget {
  final Student student;

  StudentDetailPage({required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[900],
      appBar: AppBar(
        title: Text(student.name),
        backgroundColor: Colors.teal[400],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(30, 40, 30, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: CircleAvatar(
                  backgroundImage: AssetImage(student.avatarPath),
                  radius: 40,
                ),
              ),
              Divider(
                height: 60,
                color: Colors.white,
              ),
              Text(
                'NAME',
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(height: 10),
              Text(
                student.name,
                style: TextStyle(
                  color: Colors.cyan,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),
              Text(
                'CURRENT GPA:',
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(height: 10),
              Text(
                student.gpa.toStringAsFixed(2),
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),
              Text(
                'CURRENT SEMESTER:',
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(height: 10),
              Text(
                student.currentSemester,
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 18,
                  letterSpacing: 1,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'REGISTERED COURSES:',
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              ...student.courses.map((course) => Text(
                '${course.name} - ${course.creditHours} Hours',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                  letterSpacing: 1,
                ),
              )).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
