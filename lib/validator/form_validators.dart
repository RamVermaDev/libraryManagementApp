class FormValidators {
  static String? nameValidator(value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your name';
    }
    if (value.trim().length < 3) {
      return 'Name must be at least 3 characters';
    }
    return null;
  }

  static String? emailValidator(value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? passwordValidator(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  static String? confirmPasswordValidator(value, passwordController) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  //LIBRARY NAME SCREEN

  // Library Name
  static String? libraryNameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter library name';
    }

    if (value.trim().length < 3) {
      return 'Library name must be at least 3 characters';
    }

    return null;
  }

  // WhatsApp Number
  static String? whatsappValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter WhatsApp number';
    }

    final phone = value.trim();

    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(phone)) {
      return 'Please enter a valid 10-digit number';
    }

    return null;
  }

  // Tag Line
  static String? tagLineValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a tag line';
    }

    if (value.trim().length < 5) {
      return 'Tag line is too short';
    }

    if (value.trim().length > 80) {
      return 'Tag line cannot exceed 80 characters';
    }

    return null;
  }

  // City
  static String? cityValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter city';
    }

    if (!RegExp(r"^[a-zA-Z ]+$").hasMatch(value.trim())) {
      return 'City name can contain only letters';
    }

    return null;
  }

  // State
  static String? stateValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter state';
    }

    if (!RegExp(r"^[a-zA-Z ]+$").hasMatch(value.trim())) {
      return 'State name can contain only letters';
    }

    return null;
  }

  // PIN Code
  static String? pinCodeValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter PIN code';
    }

    if (!RegExp(r'^\d{6}$').hasMatch(value.trim())) {
      return 'Please enter a valid 6-digit PIN code';
    }

    return null;
  }
}
