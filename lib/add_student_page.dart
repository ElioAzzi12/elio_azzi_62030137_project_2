import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

class AddStudentPage extends StatefulWidget {
  @override
  _AddStudentPageState createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String email = '';
  double gpa = 0.0;
  String currentSemester = 'Fall 2023-2024';

  final List<String> avatarPaths = [
    'assets/churro.png',
    'assets/castor.png',
    'assets/cat.png',
  ];

  String getRandomAvatarPath() {
    final random = Random();
    return avatarPaths[random.nextInt(avatarPaths.length)];
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final body = {
        'name': name,
        'email': email,
        'gpa': gpa.toString(),
        'currentSemester': currentSemester,
        'avatarPath': getRandomAvatarPath(),
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
        backgroundColor: Colors.teal[400],
      ),
      backgroundColor: Colors.teal[900],
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.teal[700]!,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal[700]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal[500]!),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                  onSaved: (value) => name = value!,
                  validator: (value) => value!.isEmpty ? 'Name cannot be empty' : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.teal[700]!,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal[700]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal[500]!),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: Colors.white),
                  onSaved: (value) => email = value!,
                  validator: (value) => value!.isEmpty ? 'Email cannot be empty' : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'GPA',
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.teal[700]!,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal[700]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal[500]!),
                    ),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  style: TextStyle(color: Colors.white),
                  onSaved: (value) => gpa = double.tryParse(value!) ?? 0.0,
                  validator: (value) {
                    final numVal = double.tryParse(value!);
                    if (value.isEmpty) {
                      return 'GPA cannot be empty';
                    } else if (numVal != null && (numVal > 4.0 || numVal <= 0)) {
                      return 'GPA must be more than 0 and not exceed 4.0';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Current Semester',
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.teal[700]!,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal[700]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal[500]!),
                    ),
                  ),
                  value: currentSemester,
                  items: <String>['Fall 2023-2024', 'Spring 2024', 'Summer 2024']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      currentSemester = newValue!;
                    });
                  },
                  dropdownColor: Colors.teal[700],
                  style: TextStyle(color: Colors.white),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('Create Student', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal[400],
                    ),
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
