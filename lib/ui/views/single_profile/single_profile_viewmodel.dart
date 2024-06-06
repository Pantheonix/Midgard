import 'package:dartz/dartz.dart';
import 'package:file_picker/file_picker.dart';
import 'package:midgard/app/app.locator.dart';
import 'package:midgard/app/app.logger.dart';
import 'package:midgard/models/core/file_data.dart';
import 'package:midgard/models/exceptions/eval_exception.dart';
import 'package:midgard/models/exceptions/identity_exception.dart';
import 'package:midgard/models/submission/highest_score_submission_models.dart';
import 'package:midgard/models/user/update_user_models.dart';
import 'package:midgard/models/user/user_models.dart';
import 'package:midgard/services/hive_service.dart';
import 'package:midgard/services/submission_service.dart';
import 'package:midgard/services/user_service.dart';
import 'package:midgard/ui/common/app_constants.dart';
import 'package:midgard/ui/views/single_profile/single_profile_view.form.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SingleProfileViewModel extends FormViewModel {
  SingleProfileViewModel({
    required this.userId,
  });

  final String userId;

  final _userService = locator<UserService>();
  final _submissionService = locator<SubmissionService>();
  final _hiveService = locator<HiveService>();
  final _routerService = locator<RouterService>();
  final _logger = getLogger('SingleProfileViewModel');

  final _sidebarController = SidebarXController(
    selectedIndex: kiSidebarProfilesMenuIndex,
    extended: true,
  );

  late Option<UserProfileModel> _user = none();
  late Option<FileData> _profilePicture = none();
  late Option<List<HighestScoreSubmissionModel>> _solvedProblemsSubmissions =
      none();

  Option<UserProfileModel> get user => _user;

  UserProfileModel get currentUser =>
      _hiveService.getCurrentUserProfile().getOrElse(
            () => UserProfileModel(
              userId: '',
              username: '',
              email: '',
              roles: [],
            ),
          );

  Option<FileData> get profilePicture => _profilePicture;

  Option<List<HighestScoreSubmissionModel>> get solvedProblemsSubmissions =>
      _solvedProblemsSubmissions;

  set profilePicture(Option<FileData> picture) {
    _profilePicture = picture;
    rebuildUi();
  }

  set solvedProblemsSubmissions(
    Option<List<HighestScoreSubmissionModel>> submissions,
  ) {
    _solvedProblemsSubmissions = submissions;
    rebuildUi();
  }

  HiveService get hiveService => _hiveService;

  RouterService get routerService => _routerService;

  SidebarXController get sidebarController => _sidebarController;

  Future<Option<List<HighestScoreSubmissionModel>>>
      _getSolvedProblemsSubmissionsForUser() async {
    final result = await _submissionService.getHighestScoreSubmissionsByUserId(
      userId: userId,
    );

    return await result.fold(
      (EvalException error) async {
        _logger.e('Error while retrieving solved problems: ${error.toJson()}');

        return none();
      },
      (List<HighestScoreSubmissionModel> submissions) async {
        _logger.i('Solved problems retrieved successfully');

        return some(submissions);
      },
    );
  }

  Future<Option<UserProfileModel>> _getUser(String id) async {
    final result = await _userService.getById(userId: id);

    return await result.fold(
      (IdentityException error) async {
        _logger.e('Error while retrieving user: ${error.toJson()}');

        return none();
      },
      (UserProfileModel user) async {
        _logger.i('User retrieved successfully');

        return some(user);
      },
    );
  }

  Future<void> _updateProfilePicture() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: kAllowedProfilePictureTypes,
    );

    if (result == null) return;

    final bytes = result.files.single.bytes;
    final mimeType = result.files.single.extension;
    final filename = result.files.single.name;
    final size = result.files.single.size;

    if (bytes == null || mimeType == null) return;

    if (size > kMaxProfilePictureSize) {
      _logger.e('Profile picture size is too large');
      throw Exception('Profile picture size is too large');
    }

    profilePicture = some(
      (
        bytes: bytes,
        mimeType: 'image/$mimeType',
        filename: filename,
      ),
    );
  }

  Future<void> updateProfilePicture() async {
    await runBusyFuture(
      _updateProfilePicture(),
      busyObject: kbSingleProfileKey,
    );
  }

  Future<void> _updateUser() async {
    // check client validation rules
    await runBusyFuture(
      _validate(),
      busyObject: kbSingleProfileKey,
    );

    if (hasAnyValidationMessage) return;

    final updateUserRequest = UpdateUserRequest(
      username: usernameValue == null ? none() : some(usernameValue!),
      email: emailValue == null ? none() : some(emailValue!),
      fullname: fullnameValue == null ? none() : some(fullnameValue!),
      bio: bioValue == null ? none() : some(bioValue!),
      profilePicture: profilePicture,
    );

    final result = await _userService.update(
      userId: userId,
      request: updateUserRequest,
    );

    await result.fold(
      (IdentityException error) async {
        _logger.e('Error while updating user: ${error.toJson()}');

        throw Exception(
          'Unable to update user profile: ${error.errors.asString}',
        );
      },
      (UserProfileModel user) async {
        _logger
          ..i('User updated successfully')
          ..d('User: ${user.toJson()}');

        _user = some(user);
        await _hiveService.saveCurrentUserProfile(user);
      },
    );
  }

  Future<void> updateUser() async {
    await runBusyFuture(
      _updateUser(),
      busyObject: kbSingleProfileKey,
    );
  }

  Future<void> _addRole(UserRole role) async {
    final userId = _user.fold(
      () => '',
      (user) => user.userId,
    );

    final result = await runBusyFuture(
      _userService.addRole(
        userId: userId,
        role: role,
      ),
      busyObject: kbSingleProfileKey,
    );

    await result.fold(
      (IdentityException error) async {
        _logger.e('Error while adding role: ${error.toJson()}');

        throw Exception('Unable to add role: ${error.errors.asString}');
      },
      (UserProfileModel user) {
        _logger
          ..i('Role added successfully')
          ..d('User: ${user.toJson()}');
        _user = some(user);
      },
    );
  }

  Future<void> addRole(UserRole role) async {
    await runBusyFuture(
      _addRole(role),
      busyObject: kbSingleProfileKey,
    );
  }

  Future<void> _removeRole(UserRole role) async {
    final userId = _user.fold(
      () => '',
      (user) => user.userId,
    );

    final result = await runBusyFuture(
      _userService.removeRole(
        userId: userId,
        role: role,
      ),
      busyObject: kbSingleProfileKey,
    );

    await result.fold(
      (IdentityException error) async {
        _logger.e('Error while removing role: ${error.toJson()}');

        throw Exception('Unable to remove role: ${error.errors.asString}');
      },
      (UserProfileModel user) {
        _logger
          ..i('Role removed successfully')
          ..d('User: ${user.toJson()}');
        _user = some(user);
      },
    );
  }

  Future<void> removeRole(UserRole role) async {
    await runBusyFuture(
      _removeRole(role),
      busyObject: kbSingleProfileKey,
    );
  }

  Future<void> _validate() async {
    if (hasUsernameValidationMessage) {
      throw Exception(usernameValidationMessage);
    }

    if (hasEmailValidationMessage) {
      throw Exception(emailValidationMessage);
    }

    if (hasFullnameValidationMessage) {
      throw Exception(fullnameValidationMessage);
    }

    if (hasBioValidationMessage) {
      throw Exception(bioValidationMessage);
    }
  }

  Future<void> init() async {
    _logger.i('Updating user');

    _user = await runBusyFuture(
      _getUser(userId),
      busyObject: kbSingleProfileKey,
    );

    solvedProblemsSubmissions = await runBusyFuture(
      _getSolvedProblemsSubmissionsForUser(),
      busyObject: kbSingleProfileKey,
    );

    usernameValue = _user.fold(
      () => 'Username',
      (user) => user.username,
    );

    emailValue = _user.fold(
      () => 'Email',
      (user) => user.email,
    );

    fullnameValue = _user.fold(
      () => 'Fullname',
      (user) => user.fullname,
    );

    bioValue = _user.fold(
      () => 'Bio',
      (user) => user.bio,
    );
  }
}
