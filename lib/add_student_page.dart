import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'student.dart';

class AddStudentPage extends StatefulWidget {
  @override
  _AddStudentPageState createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String email = '';
  double gpa = 0.0;
  String currentSemester = '';

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final body = {
        'name': name,
        'email': email,
        'gpa': gpa.toString(),
        'currentSemester': currentSemester,
      };

      final response = await http.post(
        Uri.parse('https://62030137.000webhostapp.com/add_student.php'),
        body: body,
      );

      if (response.statusCode == 200) {
        Navigator.of(context).pop(true);
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text("Failed to add student. Server responded with status code: ${response.statusCode}"),
              actions: <Widget>[
                TextButton(
                  child: Text("Close"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Student"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Name'),
                  onSaved: (value) => name = value!,
                  validator: (value) => value!.isEmpty ? 'Name cannot be empty' : null,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (value) => email = value!,
                  validator: (value) => value!.isEmpty ? 'Email cannot be empty' : null,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'GPA'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onSaved: (value) => gpa = double.tryParse(value!) ?? 0.0,
                  validator: (value) => value!.isEmpty ? 'GPA cannot be empty' : null,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Current Semester'),
                  onSaved: (value) => currentSemester = value!,
                  validator: (value) => value!.isEmpty ? 'Current Semester cannot be empty' : null,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('Create Student'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
