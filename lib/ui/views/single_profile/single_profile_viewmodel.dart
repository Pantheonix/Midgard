import 'package:dartz/dartz.dart';
import 'package:file_picker/file_picker.dart';
import 'package:midgard/app/app.locator.dart';
import 'package:midgard/app/app.logger.dart';
import 'package:midgard/models/exceptions/identity_exception.dart';
import 'package:midgard/models/user/update_user_models.dart';
import 'package:midgard/models/user/user_models.dart';
import 'package:midgard/services/hive_service.dart';
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
  final _hiveService = locator<HiveService>();
  final _routerService = locator<RouterService>();
  final _logger = getLogger('SingleProfileViewModel');

  final _sidebarController = SidebarXController(
    selectedIndex: kiSidebarProfilesMenuIndex,
    extended: true,
  );

  late Option<UserProfileModel> _user = none();
  late Option<ProfilePicture> _profilePicture = none();

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

  Option<ProfilePicture> get profilePicture => _profilePicture;

  set profilePicture(Option<ProfilePicture> picture) {
    _profilePicture = picture;
    notifyListeners();
  }

  HiveService get hiveService => _hiveService;

  RouterService get routerService => _routerService;

  SidebarXController get sidebarController => _sidebarController;

  Future<Option<UserProfileModel>> getUser(String id) async {
    final result = await _userService.getById(id: id);

    return result.fold(
      (IdentityException error) {
        _logger.e('Error while retrieving user: ${error.message}');
        return none();
      },
      (UserProfileModel user) {
        _logger.i('User retrieved successfully');
        return some(user);
      },
    );
  }

  Future<void> updateProfilePicture() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );

    if (result == null) return;

    final bytes = result.files.single.bytes;
    final mimeType = result.files.single.extension;
    final filename = result.files.single.name;
    if (bytes == null || mimeType == null) return;

    profilePicture = some(
      (
        bytes: bytes,
        mimeType: 'image/$mimeType',
        filename: filename,
      ),
    );
  }

  Future<void> updateUser() async {
    final updateUserRequest = UpdateUserRequest(
      username: nameValue == null ? none() : some(nameValue!),
      email: emailValue == null ? none() : some(emailValue!),
      fullname: fullnameValue == null ? none() : some(fullnameValue!),
      bio: bioValue == null ? none() : some(bioValue!),
      profilePicture: profilePicture,
    );

    final result = await runBusyFuture(
      _userService.update(
        updateUserRequest,
        userId: userId,
      ),
      busyObject: kbSingleProfileKey,
    );

    await result.fold(
      (IdentityException error) {
        _logger.e('Error while updating user: ${error.message}');
        return;
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

  Future<void> addRole(UserRole role) async {
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

    result.fold(
      (IdentityException error) {
        _logger.e('Error while adding role: ${error.message}');
        return;
      },
      (UserProfileModel user) {
        _logger
          ..i('Role added successfully')
          ..d('User: ${user.toJson()}');
        _user = some(user);
      },
    );
  }

  Future<void> removeRole(UserRole role) async {
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

    result.fold(
      (IdentityException error) {
        _logger.e('Error while removing role: ${error.message}');
        return;
      },
      (UserProfileModel user) {
        _logger
          ..i('Role removed successfully')
          ..d('User: ${user.toJson()}');
        _user = some(user);
      },
    );
  }

  Future<void> init() async {
    _logger.i('Updating user');

    _user = await runBusyFuture(
      getUser(userId),
      busyObject: kbSingleProfileKey,
    );

    nameValue = _user.fold(
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
