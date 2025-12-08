/// Input validation helpers untuk form validation
class Validators {
  /// Validate email format
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Format email tidak valid';
    }
    
    return null;
  }

  /// Validate password
  static String? password(String? value, {int minLength = 8}) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    
    if (value.length < minLength) {
      return 'Password minimal $minLength karakter';
    }
    
    return null;
  }

  /// Validate password confirmation
  static String? passwordConfirmation(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    }
    
    if (value != password) {
      return 'Password tidak sama';
    }
    
    return null;
  }

  /// Validate required field
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? "Field"} tidak boleh kosong';
    }
    return null;
  }

  /// Validate minimum length
  static String? minLength(String? value, int min, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? "Field"} tidak boleh kosong';
    }
    
    if (value.length < min) {
      return '${fieldName ?? "Field"} minimal $min karakter';
    }
    
    return null;
  }

  /// Validate maximum length
  static String? maxLength(String? value, int max, {String? fieldName}) {
    if (value != null && value.length > max) {
      return '${fieldName ?? "Field"} maksimal $max karakter';
    }
    return null;
  }

  /// Validate number
  static String? number(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? "Field"} tidak boleh kosong';
    }
    
    if (int.tryParse(value) == null) {
      return '${fieldName ?? "Field"} harus berupa angka';
    }
    
    return null;
  }

  /// Validate positive number
  static String? positiveNumber(String? value, {String? fieldName}) {
    final numberError = number(value, fieldName: fieldName);
    if (numberError != null) return numberError;
    
    if (int.parse(value!) <= 0) {
      return '${fieldName ?? "Field"} harus lebih dari 0';
    }
    
    return null;
  }

  /// Validate phone number (Indonesian format)
  static String? phoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor telepon tidak boleh kosong';
    }
    
    // Remove spaces and dashes
    final cleaned = value.replaceAll(RegExp(r'[\s-]'), '');
    
    // Check if starts with +62, 62, or 0
    final phoneRegex = RegExp(r'^(\+62|62|0)[0-9]{9,12}$');
    if (!phoneRegex.hasMatch(cleaned)) {
      return 'Format nomor telepon tidak valid';
    }
    
    return null;
  }

  /// Combine multiple validators
  static String? combine(String? value, List<String? Function(String?)> validators) {
    for (var validator in validators) {
      final error = validator(value);
      if (error != null) return error;
    }
    return null;
  }
}
