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
  late int _selectedIndex = -1;
  late int _count = 0;
  late int _page = 1;
  late SortUsersBy _sortBy = SortUsersBy.nameAsc;

  HiveService get hiveService => _hiveService;

  RouterService get routerService => _routerService;

  SidebarXController get sidebarController => _sidebarController;

  List<UserProfileModel> get users => _users;

  int get selectedIndex => _selectedIndex;

  int get count => _count;

  int get pageValue => _page;

  SortUsersBy get sortByValue => _sortBy;

  set selectedIndex(int index) {
    _selectedIndex = index;
    rebuildUi();
  }

  set pageValue(int page) {
    _page = page;
    rebuildUi();
  }

  set sortByValue(SortUsersBy sortBy) {
    _sortBy = sortBy;
    rebuildUi();
  }

  Future<List<UserProfileModel>> getUsers({
    String? name,
    String? email,
    String? sortBy,
    int? page,
    int? pageSize,
  }) async {
    final result = await _userService.getAll(
      username: name,
      sortBy: sortBy,
      page: page,
      pageSize: pageSize,
    );

    return result.fold(
      (IdentityException error) async {
        _logger.e('Error while retrieving users: ${error.toJson()}');
        return [];
      },
      (data) async {
        final (:users, :count) = data;
        _logger.i('Users retrieved: ${users.length}');

        _count = count;
        return users;
      },
    );
  }

  Future<void> init() async {
    _logger.i('Users list updated');

    _users
      ..clear()
      ..addAll(
        await runBusyFuture(
          getUsers(
            name: usernameValue,
            sortBy: sortByValue.value,
            page: pageValue == 0 ? null : pageValue,
            pageSize: kiProfilesViewPageSize,
          ),
          busyObject: kbProfilesKey,
        ),
      );
  }
}
