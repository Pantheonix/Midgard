import 'package:midgard/app/app.locator.dart';
import 'package:midgard/app/app.logger.dart';
import 'package:midgard/models/exceptions/identity_exception.dart';
import 'package:midgard/models/user/user_models.dart';
import 'package:midgard/services/hive_service.dart';
import 'package:midgard/services/user_service.dart';
import 'package:midgard/ui/common/app_constants.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ProfileViewModel extends FormViewModel {
  final _userService = locator<UserService>();
  final _hiveService = locator<HiveService>();
  final _routerService = locator<RouterService>();
  final _logger = getLogger('ProfileViewModel');

  final _sidebarController = SidebarXController(
    selectedIndex: kiSidebarProfileMenuIndex,
    extended: true,
  );

  final _users = <UserProfileModel>[];

  HiveService get hiveService => _hiveService;

  RouterService get routerService => _routerService;

  SidebarXController get sidebarController => _sidebarController;

  List<UserProfileModel> get users => _users;

  Future<List<UserProfileModel>> getUsers() async {
    final result = await _userService.getAll(
      sortBy: SortUsersBy.nameAsc.value,
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

  Future<void> initialise() async {
    _logger.i('ProfileViewModel initialised');

    _users
      ..clear()
      ..addAll(
        await runBusyFuture(
          getUsers(),
          busyObject: kbProfileKey,
        ),
      );
  }
}
