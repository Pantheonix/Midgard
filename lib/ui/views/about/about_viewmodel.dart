import 'package:midgard/app/app.locator.dart';
import 'package:midgard/app/app.logger.dart';
import 'package:midgard/services/hive_service.dart';
import 'package:midgard/ui/common/app_constants.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AboutViewModel extends BaseViewModel {
  final _hiveService = locator<HiveService>();
  final _routerService = locator<RouterService>();
  final _logger = getLogger('HomeViewModel');

  final _sidebarController = SidebarXController(
    selectedIndex: kiSidebarAboutMenuIndex,
    extended: true,
  );

  HiveService get hiveService => _hiveService;
  RouterService get routerService => _routerService;
  SidebarXController get sidebarController => _sidebarController;
}
