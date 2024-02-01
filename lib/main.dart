import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hive/hive.dart';
import 'package:midgard/app/app.bottomsheets.dart';
import 'package:midgard/app/app.dialogs.dart';
import 'package:midgard/app/app.locator.dart';
import 'package:midgard/app/app.router.dart';
import 'package:midgard/models/user/user_models.dart';
import 'package:midgard/services/services_constants.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:responsive_builder/responsive_builder.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:url_strategy/url_strategy.dart';

Future<void> main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      setPathUrlStrategy();
      await setupLocator(stackedRouter: stackedRouter);
      setupDialogUi();
      setupBottomSheetUi();

      await setupHive();
      await SentryFlutter.init(
        (options) {
          options
            ..dsn = ApiConstants.sentryDsn
            ..environment = ApiConstants.environment
            ..tracesSampleRate = 1.0;
        },
      );

      runApp(const MainApp());
    },
    (error, stack) async {
      await Sentry.captureException(error, stackTrace: stack);
    },
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveApp(
      builder: (_) => MaterialApp.router(
        routerDelegate: stackedRouter.delegate(),
        routeInformationParser: stackedRouter.defaultRouteParser(),
        debugShowCheckedModeBanner: false,
      ),
    ).animate().fadeIn(
          delay: const Duration(milliseconds: 50),
          duration: const Duration(milliseconds: 400),
        );
  }
}

Future<void> setupHive() async {
  if (!kIsWeb) {
    final appDocumentDir =
        await path_provider.getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
  }

  Hive
    ..registerAdapter(UserProfileModelAdapter())
    ..registerAdapter(UserRoleAdapter());

  await Hive.openBox<UserProfileModel>(HiveConstants.userProfileBox);
  await Hive.openBox<Uint8List>(HiveConstants.userAvatarBox);
}
