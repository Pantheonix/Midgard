import 'package:flutter/material.dart';
import 'package:midgard/app/app.router.dart';
import 'package:midgard/services/hive_service.dart';
import 'package:midgard/ui/common/app_colors.dart';
import 'package:midgard/ui/common/app_constants.dart';
import 'package:midgard/ui/common/ui_helpers.dart';
import 'package:redacted/redacted.dart';
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
            margin: const EdgeInsets.all(kdSidebarPadding),
            decoration: BoxDecoration(
              color: kcPrimaryColorDark,
              borderRadius: BorderRadius.circular(
                kdSidebarShapeRadius,
              ),
            ),
            hoverColor: kcDarkGreyColor,
            textStyle: TextStyle(color: kcWhite.withOpacity(0.7)),
            selectedTextStyle: const TextStyle(color: kcWhite),
            itemTextPadding: const EdgeInsets.only(left: kdSidebarItemPadding),
            selectedItemTextPadding: const EdgeInsets.only(
              left: kdSidebarSelectedItemPadding,
            ),
            itemDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                kdSidebarItemShapeRadius,
              ),
              border: Border.all(color: kcPrimaryColorDark),
            ),
            selectedItemDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                kdSidebarSelectedItemShapeRadius,
              ),
              border: Border.all(
                color: kcMediumGrey.withOpacity(0.37),
              ),
              gradient: const LinearGradient(
                colors: [kcDarkGreyColor, kcPrimaryColorDark],
              ),
              boxShadow: [
                BoxShadow(
                  color: kcBlack.withOpacity(0.28),
                  blurRadius: kdSidebarSelectedItemBlurRadius,
                ),
              ],
            ),
            iconTheme: IconThemeData(
              color: kcWhite.withOpacity(0.7),
              size: kdSidebarItemIconSize,
            ),
            selectedIconTheme: const IconThemeData(
              color: kcWhite,
              size: kdSidebarSelectedItemIconSize,
            ),
          ),
          extendedTheme: const SidebarXTheme(
            width: kdSidebarExtendedWidth,
            decoration: BoxDecoration(
              color: kcPrimaryColorDark,
            ),
          ),
          footerDivider: horizontalSpaceTiny,
          headerBuilder: (context, extended) {
            return SizedBox(
              height: kdSidebarHeaderHeight,
              child: Padding(
                padding: const EdgeInsets.all(kdSidebarHeaderPadding),
                child: FutureBuilder(
                  future: HiveService.avatarDataBox,
                  builder: (context, snapshot) {
                    return snapshot.connectionState == ConnectionState.done
                        ? _hiveService.getCurrentUserAvatarBlob().fold(
                              () => const FlutterLogo(size: 50).redacted(
                                context: context,
                                redact: true,
                              ),
                              (data) => CircleAvatar(
                                radius: kdSidebarAvatarShapeRadius,
                                child: Image.memory(data),
                              ),
                            )
                        : const FlutterLogo(size: 50).redacted(
                            context: context,
                            redact: true,
                          );
                  },
                ),
              ),
            );
          },
          items: [
            SidebarXItem(
              icon: Icons.home,
              label: ksSidebarHomeMenuText,
              onTap: () async {
                await _routerService.replaceWithHomeView();
              },
            ),
            SidebarXItem(
              icon: Icons.info,
              label: ksSidebarAboutMenuText,
              onTap: () async {
                await _routerService.replaceWithAboutView();
              },
            ),
            if (snapshot.connectionState == ConnectionState.done)
              ..._hiveService.getCurrentUserProfile().isNone()
                  ? [
                      SidebarXItem(
                        icon: Icons.login_outlined,
                        label: ksSidebarLoginMenuText,
                        onTap: () async {
                          await _routerService.replaceWithLoginView();
                        },
                      ),
                      SidebarXItem(
                        icon: Icons.add_circle,
                        label: ksSidebarRegisterMenuText,
                        onTap: () async {
                          await _routerService.replaceWithRegisterView();
                        },
                      ),
                    ]
                  : [
                      SidebarXItem(
                        icon: Icons.logout,
                        label: ksSidebarLogoutMenuText,
                        onTap: () async {
                          await _hiveService.clearUserProfile();
                          await _routerService.navigateTo(
                            const HomeViewRoute(),
                          );
                        },
                      ),
                      SidebarXItem(
                        icon: Icons.account_circle,
                        label: ksSidebarProfileMenuText,
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
