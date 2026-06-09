class Validators {
  static String? numberValidator(String? value) {
    if (value == null || value.isEmpty) return 'Required';
    final number = int.tryParse(value);
    if (number == null) {
      return 'Enter a valid number';
    }
    return null;
  }

  static String? doubleValidator(String? value) {
    if (value == null || value.isEmpty) return 'Required';
    final number = double.tryParse(value);
    if (number == null) {
      return 'Enter a valid decimal number';
    }
    return null;
  }

  static String? requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }
}
