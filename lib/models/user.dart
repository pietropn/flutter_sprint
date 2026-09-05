class User {
  final String email;
  final String name;

  User({required this.email, required this.name});

  factory User.fromJson(Map<String, dynamic> j) => User(email: j['email'] ?? '', name: j['name'] ?? '');
  Map<String, dynamic> toJson() => {'email': email, 'name': name};
}