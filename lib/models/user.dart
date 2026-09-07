import 'role.dart';

class User {
  final String email;
  final String name;

  /// Papel escolhido localmente no login (Gestor/Professor). A API do
  /// projeto ainda não possui esse conceito, então é tratado apenas no app.
  final Role role;

  User({required this.email, required this.name, this.role = Role.gestor});

  factory User.fromJson(Map<String, dynamic> j) => User(
        email: j['email']?.toString() ?? '',
        name: j['name']?.toString() ?? '',
        role: RoleX.fromString(j['role']?.toString()),
      );

  Map<String, dynamic> toJson() => {
        'email': email,
        'name': name,
        'role': role.asString,
      };
}