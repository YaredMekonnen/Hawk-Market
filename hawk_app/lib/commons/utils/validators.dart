String? emailValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Email is required';
  }
  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
    return 'Please enter a valid email';
  }
  return null;
}

String? textValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'This field is required';
  }
  if (value.length < 5) {
    return 'Can\'t be less than 5 characters';
  }
  if (value.length > 15) {
    return 'Can\'t be greater than 15 characters';
  }
  return null;
}

String? discriptionValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'This field is required';
  }
  if (value.length < 20) {
    return 'Can\'t be less than 5 characters';
  }
  return null;
}

String? priceValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'This field is required';
  }
  if (int.tryParse(value) == null) {
    return 'Please enter a valid number';
  }
  if (value[0] == '0') {
    return 'Price can\'t be less than 1';
  }
  if (value.length > 5) {
    return 'Must not be greater 100,000';
  }
  return null;
}

String? passwordValidator(String? password) {
  if (password == null || password.isEmpty) {
    return 'Password is required';
  }

  // Check for at least one uppercase letter
  bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
  if (!hasUppercase) {
    return 'Password must contain at least one uppercase letter';
  }

  // Check for at least one lowercase letter
  bool hasLowercase = password.contains(RegExp(r'[a-z]'));
  if (!hasLowercase) {
    return 'Password must contain at least one lowercase letter';
  }

  // Check for at least one number
  bool hasNumber = password.contains(RegExp(r'[0-9]'));
  if (!hasNumber) {
    return 'Password must contain at least one number';
  }

  return null;
}

String? confirmPasswordValidator(String? value, String password) {
  if (value == null || value.isEmpty) {
    return 'Password confirmation is required';
  }

  if (value != password) {
    return 'Password must match';
  }

  return null;
}
