import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'student.dart';
import 'student_details.dart';
import 'add_student_page.dart';

class UniversityID extends StatefulWidget {
  @override
  _UniversityIDState createState() => _UniversityIDState();
}

class _UniversityIDState extends State<UniversityID> {
  List<Student> students = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  void fetchStudents() async {
    setState(() { isLoading = true; });

    final url = Uri.parse('https://62030137.000webhostapp.com/get_students.php');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        Iterable jsonResponse = json.decode(response.body);
        List<Student> studentsList = jsonResponse.map((student) => Student.fromJson(student)).toList();
        setState(() {
          students = studentsList;
        });
      } else {
        print('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Caught error: $e');
    }

    setState(() { isLoading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[900],
      appBar: AppBar(
        title: Text('University Dashboard'),
        backgroundColor: Colors.teal[400],
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: fetchStudents,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.white))
          : students.isEmpty
          ? Center(child: Text("No students found.", style: TextStyle(color: Colors.white)))
          : ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.teal[800],
            child: ListTile(
              title: Text(students[index].name, style: TextStyle(color: Colors.white)),
              subtitle: Text(students[index].email, style: TextStyle(color: Colors.white70)),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => StudentDetailPage(student: students[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddStudentPage()),
          );

          if (result != null) {
            fetchStudents();
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.teal[400],
      ),
    );
  }
}
