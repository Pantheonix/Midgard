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

class ProfileViewModel extends FutureViewModel<List<UserProfileModel>> {
  final _userService = locator<UserService>();
  final _hiveService = locator<HiveService>();
  final _routerService = locator<RouterService>();
  final _logger = getLogger('ProfileViewModel');

  final _sidebarController = SidebarXController(
    selectedIndex: kiSidebarProfileMenuIndex,
    extended: true,
  );

  HiveService get hiveService => _hiveService;

  RouterService get routerService => _routerService;

  SidebarXController get sidebarController => _sidebarController;

  @override
  Future<List<UserProfileModel>> futureToRun() => getUsers();

  Future<List<UserProfileModel>> getUsers() async {
    final result = await _userService.getAll();

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
}
