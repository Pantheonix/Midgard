import 'package:midgard/services/services_constants.dart';

Uri uriFromEnv(
  String authority,
  String unencodedPath,
) =>
    switch (ApiConstants.environment) {
      'prod' => Uri.https(authority, unencodedPath),
      _ => Uri.http(authority, unencodedPath),
    };
