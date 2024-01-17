import 'package:midgard/services/services_constants.dart';

Uri uriFromEnv(
  String authority,
  String unencodedPath, {
  Map<String, String>? queryParams,
}) =>
    switch (ApiConstants.environment) {
      'prod' => Uri.https(authority, unencodedPath, queryParams),
      _ => Uri.http(authority, unencodedPath, queryParams),
    };
