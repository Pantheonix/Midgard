import 'package:midgard/app/app.locator.dart';
import 'package:midgard/app/app.logger.dart';
import 'package:midgard/models/exceptions/identity_exception.dart';
import 'package:midgard/models/user/user_models.dart';
import 'package:midgard/services/hive_service.dart';
import 'package:midgard/services/user_service.dart';
import 'package:midgard/ui/common/app_constants.dart';
import 'package:midgard/ui/views/profiles/profiles_view.form.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ProfilesViewModel extends FormViewModel {
  final _userService = locator<UserService>();
  final _hiveService = locator<HiveService>();
  final _routerService = locator<RouterService>();
  final _logger = getLogger('ProfilesViewModel');

  final _sidebarController = SidebarXController(
    selectedIndex: kiSidebarProfilesMenuIndex,
    extended: true,
  );

  final _users = <UserProfileModel>[];

  HiveService get hiveService => _hiveService;

  RouterService get routerService => _routerService;

  SidebarXController get sidebarController => _sidebarController;

  List<UserProfileModel> get users => _users;

  Future<List<UserProfileModel>> getUsers({
    String? name,
    String? email,
    String? sortBy,
    int? page,
    int? pageSize,
  }) async {
    final result = await _userService.getAll(
      name: name,
      email: email,
      sortBy: sortBy,
      page: page,
      pageSize: pageSize,
    );

    return result.fold(
      (IdentityException error) {
        _logger.e('Error while retrieving users: ${error.message}');
        return [];
      },
      (List<UserProfileModel> users) {
        _logger.i('Users retrieved: ${users.length}');
        return users;
      },
    );
  }

  Future<void> reinitialize() async {
    _logger.i('Users list reinitialized');

    _users
      ..clear()
      ..addAll(
        await runBusyFuture(
          getUsers(
            name: nameValue,
            email: emailValue,
            sortBy: sortByValue,
            page: pageValue == null || pageValue!.isEmpty
                ? null
                : int.parse(pageValue!),
            pageSize: pageSizeValue == null || pageSizeValue!.isEmpty
                ? null
                : int.parse(pageSizeValue!),
          ),
          busyObject: kbProfilesKey,
        ),
      );
  }
}
