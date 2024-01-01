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

  Map<String, dynamic> toJson() {
    return {
      'id': id.toString(),
      'name': name,
      'creditHours': creditHours.toString(),
    };
  }
}
