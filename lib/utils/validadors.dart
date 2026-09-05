String? validateEmail(String? v) {
  if (v == null || v.trim().isEmpty) return 'Email obrigatório';
  final re = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  if (!re.hasMatch(v.trim())) return 'Email inválido';
  return null;
}

String? validateRequired(String? v, {String message = 'Campo obrigatório'}) {
  if (v == null || v.trim().isEmpty) return message;
  return null;
}

String? validateMinLength(String? v, int min, {String? message}) {
  if (v == null || v.length < min) return message ?? 'Mínimo de $min caracteres';
  return null;
}