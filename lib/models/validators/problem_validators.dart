import 'package:midgard/ui/common/app_constants.dart';

class ProblemValidators {
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required!';
    }

    if (value.length > kMaxProblemNameLength ||
        value.length < kMinProblemNameLength) {
      return 'Name must be between $kMinProblemNameLength-$kMaxProblemNameLength characters long!';
    }

    return null;
  }

  static String? validateBrief(String? value) {
    if (value == null || value.isEmpty) {
      return 'Brief is required!';
    }

    if (value.length > kMaxProblemBriefLength ||
        value.length < kMinProblemBriefLength) {
      return 'Brief must be between $kMinProblemBriefLength-$kMaxProblemBriefLength characters long!';
    }

    return null;
  }

  static String? validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Description is required!';
    }

    if (value.length > kMaxProblemDescriptionLength ||
        value.length < kMinProblemDescriptionLength) {
      return 'Description must be between $kMinProblemDescriptionLength-$kMaxProblemDescriptionLength characters long!';
    }

    return null;
  }

  static String? validateSourceName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Source name is required!';
    }

    if (value.length > kMaxProblemSourceNameLength ||
        value.length < kMinProblemSourceNameLength) {
      return 'Source name must be between $kMinProblemSourceNameLength-$kMaxProblemSourceNameLength characters long!';
    }

    return null;
  }

  static String? validateAuthorName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Author name is required!';
    }

    if (value.length > kMaxProblemAuthorNameLength ||
        value.length < kMinProblemAuthorNameLength) {
      return 'Author name must be between $kMinProblemAuthorNameLength-$kMaxProblemAuthorNameLength characters long!';
    }

    return null;
  }

  static String? validateTimeLimit(String? value) {
    if (value == null || value.isEmpty) {
      return 'Time limit is required!';
    }

    if (double.tryParse(value) == null ||
        RegExp(kLimitDecimalRegex).hasMatch(value) == false) {
      return 'Time limit must be a number!';
    }

    if (double.parse(value) < kMinProblemTimeLimit ||
        double.parse(value) > kMaxProblemTimeLimit) {
      return 'Time limit must be between $kMinProblemTimeLimit-$kMaxProblemTimeLimit sec!';
    }

    return null;
  }

  static String? validateTotalMemoryLimit(String? value) {
    if (value == null || value.isEmpty) {
      return 'Total memory limit is required!';
    }

    if (double.tryParse(value) == null ||
        RegExp(kLimitDecimalRegex).hasMatch(value) == false) {
      return 'Total memory limit must be a number!';
    }

    if (double.parse(value) < kMinProblemTotalMemoryLimit ||
        double.parse(value) > kMaxProblemTotalMemoryLimit) {
      return 'Total memory limit must be between $kMinProblemTotalMemoryLimit-$kMaxProblemTotalMemoryLimit MB!';
    }

    return null;
  }

  static String? validateStackMemoryLimit(String? value) {
    if (value == null || value.isEmpty) {
      return 'Stack memory limit is required!';
    }

    if (double.tryParse(value) == null ||
        RegExp(kLimitDecimalRegex).hasMatch(value) == false) {
      return 'Stack memory limit must be a number!';
    }

    if (double.parse(value) < kMinProblemStackMemoryLimit ||
        double.parse(value) > kMaxProblemStackMemoryLimit) {
      return 'Stack memory limit must be between $kMinProblemStackMemoryLimit-$kMaxProblemStackMemoryLimit MB!';
    }

    return null;
  }

  static String? validateTestScore(String? value) {
    if (value == null || value.isEmpty) {
      return 'Test score is required!';
    }

    if (double.tryParse(value) == null ||
        RegExp(kLimitDecimalRegex).hasMatch(value) == false) {
      return 'Test score must be a number!';
    }

    if (double.parse(value) < kMinProblemTestScore ||
        double.parse(value) > kMaxProblemTestScore) {
      return 'Test score must be between $kMinProblemTestScore-$kMaxProblemTestScore!';
    }

    return null;
  }
}
