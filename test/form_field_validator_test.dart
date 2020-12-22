import 'package:test/test.dart';
import 'package:dima_project/shared/form_validators.dart';

void main() {
  test('1 - empty email returns error string', () {
    var result = EmailFieldValidator.validate('');
    expect(result, 'Enter an email');
  });

  test('2 - non empty email returns null', () {
    var result = EmailFieldValidator.validate('test');
    expect(result, null);
  });

  test('3 - empty password field returns error string', () {
    var result = PasswordFieldValidator.validate('');
    expect(result, 'Enter a password of at least 8 characters');
  });

  test('4 - seven char password field returns error string', () {
    var result = PasswordFieldValidator.validate('asdfghj');
    expect(result, 'Enter a password of at least 8 characters');
  });

  test('5 - eight char password field returns null', () {
    var result = PasswordFieldValidator.validate('asdfghjk');
    expect(result, null);
  });

  test('6 - username empty field return errror string', () {
    var result = UsernameFieldValidator.validate('');
    expect(result, 'Enter an username (max 20 char)');
  });

  test('7 - 21 char username field return errror string', () {
    var result = UsernameFieldValidator.validate('123456789012345678901');
    expect(result, 'Enter an username (max 20 char)');
  });

  test('8 - 20 char username field return null', () {
    var result = UsernameFieldValidator.validate('12345678901234567890');
    expect(result, null);
  });

  test('9 - Number field with numbers return null', () {
    var result = NumberFieldValidator.validate('230894673');
    expect(result, null);
  });

  test('10 - Number field with characters return error string', () {
    var result = NumberFieldValidator.validate('23089a4673');
    expect(result, 'Enter a number');
  });
}
