import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'student.dart';
import 'course.dart';
import 'register_courses_page.dart';

class StudentDetailPage extends StatefulWidget {
  final Student student;

  StudentDetailPage({required this.student});

  @override
  _StudentDetailPageState createState() => _StudentDetailPageState();
}

class _StudentDetailPageState extends State<StudentDetailPage> {
  bool isEditMode = false;
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController gpaController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.student.name);
    emailController = TextEditingController(text: widget.student.email);
    gpaController = TextEditingController(text: widget.student.gpa.toString());
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    gpaController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      isEditMode = !isEditMode;
    });
  }

  void _deleteStudent() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Student'),
          content: Text('Are you sure you want to delete this student?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Yes'),
            ),
          ],
        );
      },
    ) ?? false;

    if (shouldDelete) {
      final response = await http.post(
        Uri.parse('https://62030137.000webhostapp.com/delete_student.php'),
        body: {'id': widget.student.id.toString()},
      );

      if (response.statusCode == 200) {
        Navigator.of(context).pop(true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete student: ${response.body}')),
        );
      }
    }
  }

  void _saveChanges() async {
    final updateData = {
      'id': widget.student.id.toString(),
      'name': nameController.text,
      'email': emailController.text,
      'gpa': gpaController.text,
      'currentSemester': widget.student.currentSemester,
      'avatarPath': widget.student.avatarPath
    };

    final response = await http.post(
      Uri.parse('https://62030137.000webhostapp.com/update_student.php'),
      body: updateData,
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Student updated successfully!')));
      setState(() {
        isEditMode = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update student!')));
    }
  }

  void navigateAndDisplaySelection(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterCoursesPage(student: widget.student),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[900],
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Student' : 'Student Details'),
        backgroundColor: Colors.teal[400],
        actions: <Widget>[
          IconButton(
            icon: Icon(isEditMode ? Icons.save : Icons.edit),
            onPressed: isEditMode ? _saveChanges : _toggleEditMode,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _deleteStudent,
          ),
          IconButton(
            icon: Icon(Icons.book),
            onPressed: () => navigateAndDisplaySelection(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(30, 40, 30, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: CircleAvatar(
                  backgroundImage: AssetImage(widget.student.avatarPath),
                  radius: 40,
                ),
              ),
              Divider(
                height: 60,
                color: Colors.white,
              ),
              isEditMode
                  ? TextFormField(
                controller: nameController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: Colors.white),
                ),
              )
                  : Text(
                'Name: ${widget.student.name}',
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 2,
                  fontSize: 24,
                ),
              ),
              SizedBox(height: 20),
              isEditMode
                  ? TextFormField(
                controller: emailController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.white),
                ),
              )
                  : Text(
                'Email: ${widget.student.email}',
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 2,
                  fontSize: 24,
                ),
              ),
              SizedBox(height: 20),
              isEditMode
                  ? TextFormField(
                controller: gpaController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'GPA',
                  labelStyle: TextStyle(color: Colors.white),
                ),
              )
                  : Text(
                'GPA: ${widget.student.gpa.toStringAsFixed(2)}',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),
              Text(
                'Current Semester: ${widget.student.currentSemester}',
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 2,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Registered Courses:',
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 2,
                  fontSize: 18,
                ),
              ),
              ...widget.student.courses.map((course) => Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  '${course.name} - ${course.creditHours} Hours',
                  style: TextStyle(
                    color: Colors.red[300],
                    fontSize: 18,
                    letterSpacing: 1,
                  ),
                ),
              )),
              SizedBox(height: 20),
              if (isEditMode)
                Center(
                  child: ElevatedButton(
                    onPressed: _saveChanges,
                    child: Text('Save Changes', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.teal[400],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}