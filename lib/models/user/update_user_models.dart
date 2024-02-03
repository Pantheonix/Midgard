import 'dart:typed_data';

import 'package:dartz/dartz.dart';

typedef ProfilePicture = ({
  Uint8List bytes,
  String mimeType,
  String filename,
});

class UpdateUserRequest {
  UpdateUserRequest({
    required this.username,
    required this.email,
    required this.fullname,
    required this.bio,
    required this.profilePicture,
  });

  final Option<String> username;
  final Option<String> email;
  final Option<String> fullname;
  final Option<String> bio;
  final Option<ProfilePicture> profilePicture;
}
