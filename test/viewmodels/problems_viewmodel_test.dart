import 'package:flutter_test/flutter_test.dart';
import 'package:midgard/app/app.locator.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('ProblemsViewModel Tests -', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());
  });
}
