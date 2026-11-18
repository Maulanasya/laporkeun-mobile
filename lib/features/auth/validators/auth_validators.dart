String? requiredValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Wajib diisi';
  }
  return null;
}

String? emailValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Email wajib diisi';
  }

  final email = value.trim();
  if (!email.contains('@') || !email.contains('.')) {
    return 'Format email tidak valid';
  }

  return null;
}
