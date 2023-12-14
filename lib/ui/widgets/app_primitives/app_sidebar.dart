import 'package:flutter/material.dart';
import 'package:midgard/app/app.router.dart';
import 'package:midgard/services/hive_service.dart';
import 'package:midgard/ui/common/app_colors.dart';
import 'package:midgard/ui/common/ui_helpers.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:stacked_services/stacked_services.dart';

class AppSidebar extends StatelessWidget {
  const AppSidebar({
    required SidebarXController controller,
    required RouterService routerService,
    required HiveService hiveService,
    super.key,
  })  : _controller = controller,
        _routerService = routerService,
        _hiveService = hiveService;

  final SidebarXController _controller;
  final RouterService _routerService;
  final HiveService _hiveService;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: HiveService.userProfileBox,
      builder: (context, snapshot) {
        return SidebarX(
          controller: _controller,
          theme: SidebarXTheme(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: kcPrimaryColorDark,
              borderRadius: BorderRadius.circular(20),
            ),
            hoverColor: kcDarkGreyColor,
            textStyle: TextStyle(color: kcWhite.withOpacity(0.7)),
            selectedTextStyle: const TextStyle(color: kcWhite),
            itemTextPadding: const EdgeInsets.only(left: 30),
            selectedItemTextPadding: const EdgeInsets.only(left: 30),
            itemDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: kcPrimaryColorDark),
            ),
            selectedItemDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: kcMediumGrey.withOpacity(0.37),
              ),
              gradient: const LinearGradient(
                colors: [kcDarkGreyColor, kcPrimaryColorDark],
              ),
              boxShadow: [
                BoxShadow(
                  color: kcBlack.withOpacity(0.28),
                  blurRadius: 30,
                ),
              ],
            ),
            iconTheme: IconThemeData(
              color: kcWhite.withOpacity(0.7),
              size: 20,
            ),
            selectedIconTheme: const IconThemeData(
              color: kcWhite,
              size: 20,
            ),
          ),
          extendedTheme: const SidebarXTheme(
            width: 200,
            decoration: BoxDecoration(
              color: kcPrimaryColorDark,
            ),
          ),
          footerDivider: horizontalSpaceTiny,
          headerBuilder: (context, extended) {
            return const SizedBox(
              height: 100,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: FlutterLogo(size: 50),
              ),
            );
          },
          items: [
            SidebarXItem(
              icon: Icons.home,
              label: 'Home',
              onTap: () async {
                await _routerService.replaceWithHomeView();
              },
            ),
            SidebarXItem(
              icon: Icons.info,
              label: 'About',
              onTap: () async {
                // await _routerService.replaceWithAboutView();
              },
            ),
            if (snapshot.connectionState == ConnectionState.done)
              ..._hiveService.getCurrentUserProfile().isNone()
                  ? [
                      SidebarXItem(
                        icon: Icons.login_outlined,
                        label: 'Login',
                        onTap: () async {
                          await _routerService.replaceWithLoginView();
                        },
                      ),
                      SidebarXItem(
                        icon: Icons.add_circle,
                        label: 'Register',
                        onTap: () async {
                          await _routerService.replaceWithRegisterView();
                        },
                      ),
                    ]
                  : [
                      SidebarXItem(
                        icon: Icons.logout,
                        label: 'Logout',
                        onTap: () async {
                          await _hiveService.clearUserProfile();
                          await _routerService.navigateTo(
                            const HomeViewRoute(),
                          );
                        },
                      ),
                      SidebarXItem(
                        icon: Icons.account_circle,
                        label: 'Profile',
                        onTap: () async {
                          // await _routerService.replaceWithProfileView();
                        },
                      ),
                    ],
          ],
        );
      },
    );
  }
}
