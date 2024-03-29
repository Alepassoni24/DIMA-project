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

//validator for number fields in order to check that they are a valid number
class NumberFieldValidator {
  static String validate(String value) {
    return (int.tryParse(value) == null || int.parse(value) <= 0) &&
            (double.tryParse(value) == null || double.parse(value) <= 0)
        ? 'Enter a number'
        : null;
  }
}

//validator for title fields in order to check that they are not empty
class TitleFieldValidator {
  static String validate(String value) {
    return (value == null || value.isEmpty || value.length > 30)
        ? 'Enter a title (max 30 char)'
        : null;
  }
}

//validator for subtitle fields in order to check that they are not empty
class SubtitleFieldValidator {
  static String validate(String value) {
    return (value == null || value.isEmpty || value.length > 50)
        ? 'Enter a subtitle (max 50 char)'
        : null;
  }
}

//validator for subtitle fields in order to check that they are not empty
class UnitFieldValidator {
  static String validate(String value) {
    return (value == null || value.isEmpty || value.length > 6)
        ? 'Enter a unit (max 6 char)'
        : null;
  }
}

//validator for description fields in order to check that they are not empty
class DescriptionFieldValidator {
  static String validate(String value) {
    return (value == null || value.isEmpty || value.length > 1000)
        ? 'Enter a description (max 1000 char)'
        : null;
  }
}

//validator for ingredient fields in order to check that they are not empty
class IngredientFieldValidator {
  static String validate(String value) {
    return (value == null || value.isEmpty || value.length > 20)
        ? 'Enter an ingredient (max 20 char)'
        : null;
  }
}
