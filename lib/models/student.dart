class Student {
  final String id;
  final String name;
  final String cpf;
  final String email;
  final String turma;

  Student({
    required this.id,
    required this.name,
    this.cpf = '',
    required this.email,
    this.turma = '',
  });

  /// Mapeamento para persistência local (cache SharedPreferences)
  factory Student.fromMap(Map<String, dynamic> m) => Student(
        id: m['id']?.toString() ?? '',
        name: m['name'] ?? m['nome'] ?? '',
        cpf: m['cpf']?.toString() ?? '',
        email: m['email'] ?? '',
        turma: m['turma'] ?? '',
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'cpf': cpf,
        'email': email,
        'turma': turma,
      };

  /// Mapeamento para/de API Spring Boot (Sprint_microservico - /alunos)
  factory Student.fromApiJson(Map<String, dynamic> m) => Student(
        id: m['id']?.toString() ?? '',
        name: m['nome'] ?? m['name'] ?? '',
        cpf: m['cpf']?.toString() ?? '',
        email: m['email'] ?? '',
        turma: m['turma']?.toString() ?? '',
      );

  Map<String, dynamic> toApiJson() => {
        if (id.isNotEmpty && int.tryParse(id) != null) 'id': int.parse(id),
        'nome': name,
        'cpf': cpf.replaceAll(RegExp(r'\D'), '').padLeft(11, '0'),
        'email': email,
        'turma': turma,
      };

  Student copyWith({
    String? id,
    String? name,
    String? cpf,
    String? email,
    String? turma,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      cpf: cpf ?? this.cpf,
      email: email ?? this.email,
      turma: turma ?? this.turma,
    );
  }
}