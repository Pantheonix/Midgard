import 'package:midgard/app/app.locator.dart';
import 'package:midgard/services/hive_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AppSidebarViewModel extends BaseViewModel {
  final _routerService = locator<RouterService>();
  final _hiveService = locator<HiveService>();

  HiveService get hiveService => _hiveService;

  RouterService get routerService => _routerService;
}
