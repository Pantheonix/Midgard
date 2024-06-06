import 'package:midgard/ui/common/app_constants.dart';

class UserValidators {
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required!';
    }

    if (value.length < kMinUsernameLength) {
      return 'Username must be at least $kMinUsernameLength characters long!';
    }

    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required!';
    }

    if (!RegExp(kEmailRegex).hasMatch(value)) {
      return 'Email must be a valid email address!';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required!';
    }

    if (value.length < kMinPasswordLength ||
        value.length > kMaxPasswordLength ||
        !RegExp(kPasswordRegex).hasMatch(value)) {
      return 'Password must be between $kMinPasswordLength-$kMaxPasswordLength'
          ' characters long, contain at least one'
          ' uppercase letter, one lowercase letter, one number'
          ' and one special character!';
    }

    return null;
  }

  static String? validateConfirmPassword(
    String? value,
    String? password,
  ) {
    if (value == null || value.isEmpty) {
      return 'Confirm password is required!';
    }

    if (value != password) {
      return 'Confirm password must match password!';
    }

    return null;
  }

  static String? validateFullname(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    if (value.length > kMaxFullnameLength) {
      return 'Fullname must be less than $kMaxFullnameLength characters long!';
    }

    return null;
  }

  static String? validateBio(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    if (value.length > kMaxBioLength) {
      return 'Bio must be less than $kMaxBioLength characters long!';
    }

    return null;
  }
}
