import 'package:midgard/app/app.locator.dart';
import 'package:midgard/app/app.logger.dart';
import 'package:midgard/services/hive_service.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
  final _dialogService = locator<DialogService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final _hiveService = locator<HiveService>();
  final _routerService = locator<RouterService>();
  final _logger = getLogger('HomeViewModel');

  final _sidebarController = SidebarXController(
    selectedIndex: 0,
    extended: true,
  );

  HiveService get hiveService => _hiveService;
  RouterService get routerService => _routerService;
  SidebarXController get sidebarController => _sidebarController;

  List<({String path, String text})> get assetCardsList => [
        (path: 'assets/images/quetzalcoatl.jpg', text: 'Quetzalcoatl'),
        (path: 'assets/images/anubis.jpg', text: 'Anubis'),
        (path: 'assets/images/enki.jpg', text: 'Enki'),
        (path: 'assets/images/hermes.jpg', text: 'Hermes'),
      ];
}
