import 'package:test/test.dart';
import 'package:dima_project/screens/authenticate/sign_in.dart';

void main() {
  test('1 - empty email returns error string', () {
    var result = EmailFieldValidator.validate('');
    expect(result, 'Enter an email');
  });

  test('2 - non empty email returns null', () {
    var result = EmailFieldValidator.validate('test');
    expect(result, null);
  });
}
