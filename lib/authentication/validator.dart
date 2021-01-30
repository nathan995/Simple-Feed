mixin Validator {
  final RegExp _exp = new RegExp(r'^\d+$');

  validatePhone(String phone) {
    if (phone.isEmpty) {
      return 'Please enter your phone number';
    } else if (!(_exp.hasMatch(phone) &&
        ((phone.startsWith('9') && phone.length == 9) ||
            (phone.length == 10 && phone.startsWith('0'))))) {
      return 'Invalid phone number';
    }
    return null;
  }

  validateCode(String code) {
    if (code.isEmpty) {
      return 'Please enter verification code';
    } else if (code.length != 6) {
      return 'Invalid code';
    }
    return null;
  }
}
