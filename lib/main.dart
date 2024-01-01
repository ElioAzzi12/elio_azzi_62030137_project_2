import 'package:flutter/material.dart';
import 'universityID.dart';

void main() {
  runApp(UniversityApp());
}

class UniversityApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'University Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: UniversityID(),
    );
  }
}
