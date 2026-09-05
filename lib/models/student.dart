class Student {
  final String id;
  final String name;
  final String email;
  final String turma;

  Student({required this.id, required this.name, required this.email, required this.turma});

  factory Student.fromMap(Map<String, dynamic> m) => Student(
        id: m['id']?.toString() ?? '',
        name: m['name'] ?? '',
        email: m['email'] ?? '',
        turma: m['turma'] ?? '',
      );

  Map<String, dynamic> toMap() => {'id': id, 'name': name, 'email': email, 'turma': turma};
}