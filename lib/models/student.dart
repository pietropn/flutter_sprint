class Student {
  final String id;
  final String name;
  final String email;
  final String turma;

  Student({
    required this.id,
    required this.name,
    required this.email,
    required this.turma,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'turma': turma,
      };

  factory Student.fromMap(Map<dynamic, dynamic> map) {
    return Student(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      turma: map['turma'] ?? '',
    );
  }
}