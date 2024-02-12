import 'package:dartz/dartz.dart';
import 'package:midgard/models/core/file_data.dart';

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
  final Option<FileData> profilePicture;
}
