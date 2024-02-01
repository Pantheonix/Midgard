import 'package:dartz/dartz.dart';
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

  HiveService get hiveService => _hiveService;

  RouterService get routerService => _routerService;

  SidebarXController get sidebarController => _sidebarController;

  Option<UserProfileModel> get user => _user;

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

  Future<void> update() async {
    _logger.i('Updating user');

    _user = await runBusyFuture(
      getUser(userId),
      busyObject: kbSingleProfileKey,
    );
  }
}
