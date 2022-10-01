class Validator {
  static final RegExp _validEmailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  //  Matches passwords with at least:
  //    - 8 characters
  //    - One letter
  //    - One number
  //    - One special character
  static final RegExp _validPasswordRegex =
      RegExp(r"^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$");

  /// Returns true if [email] is a valid email address.
  static bool _isValidEmail(String email) {
    return _validEmailRegex.hasMatch(email);
  }

  /// Returns true if [password] satisfies password requirements.
  static bool _isValidPassword(String password) {
    return _validPasswordRegex.hasMatch(password);
  }

  static const passwordSpecifications = """
      \n* 8 - 20 characters in length
      \n* At least One letter
      \n* At least One number
      \n* At least One special character
    """;

  static String? validateEmail(String? s) {
    if (s == null || s.isEmpty) {
      return "Please provide a value";
    } else if (!_isValidEmail(s)) {
      return "Please provide a valid email";
    }
    return null;
  }

  static String? validatePassword(String? s, {bool showValidPassMsg = false}) {
    if (s == null || s.isEmpty) {
      return "Please provide a value";
    } else if (showValidPassMsg && !_isValidPassword(s)) {
      return "Please provide a valid password";
    }
    return null;
  }
}
