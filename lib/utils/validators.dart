String? validateEmail(String? value) {
  if (value == null || value.isEmpty) return 'Email obrigatório';
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  if (!emailRegex.hasMatch(value)) return 'Email inválido';
  return null;
}

String? validateRequired(String? value, {String message = 'Campo obrigatório'}) {
  if (value == null || value.trim().isEmpty) return message;
  return null;
}