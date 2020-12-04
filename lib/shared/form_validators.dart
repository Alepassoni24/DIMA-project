//validator for email fields in order to check that they are not empty
class EmailFieldValidator {
  static String validate(String value) {
    return value.isEmpty ? 'Enter an email' : null;
  }
}

//validator for password fields in order to check if they are smaller than 8 caracters
class PasswordFieldValidator {
  static String validate(String value) {
    return value.length < 8
        ? 'Enter a password of at least 8 characters'
        : null;
  }
}

//validator for username fields in order to check if they are empty or greater than 20 char
class UsernameFieldValidator {
  static String validate(String value) {
    return (value.isEmpty || value.length > 20)
        ? 'Enter an username (max 20 char)'
        : null;
  }
}
