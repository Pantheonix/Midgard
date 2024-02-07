import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:midgard/app/app.bottomsheets.dart';
import 'package:midgard/app/app.dialogs.dart';
import 'package:midgard/app/app.locator.dart';
import 'package:midgard/app/app.router.dart';
import 'package:midgard/services/hive_service.dart';
import 'package:midgard/services/services_constants.dart';
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

      await HiveService.init();
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
        scrollBehavior: const MaterialScrollBehavior().copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
          },
        ),
      ),
    ).animate().fadeIn(
          delay: const Duration(milliseconds: 50),
          duration: const Duration(milliseconds: 400),
        );
  }
}
