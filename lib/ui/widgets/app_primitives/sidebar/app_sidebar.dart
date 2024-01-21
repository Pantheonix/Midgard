import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:midgard/app/app.router.dart';
import 'package:midgard/services/hive_service.dart';
import 'package:midgard/ui/common/app_colors.dart';
import 'package:midgard/ui/common/app_constants.dart';
import 'package:midgard/ui/common/ui_helpers.dart';
import 'package:midgard/ui/widgets/app_primitives/sidebar/app_sidebar_viewmodel.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:stacked/stacked.dart';

class AppSidebar extends StatelessWidget {
  const AppSidebar({
    required SidebarXController controller,
    super.key,
  }) : _controller = controller;

  final SidebarXController _controller;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AppSidebarViewModel>.nonReactive(
      builder: (context, viewModel, child) {
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
                itemTextPadding:
                    const EdgeInsets.only(left: kdSidebarItemPadding),
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
                    child: CachedNetworkImage(
                      imageUrl: snapshot.connectionState ==
                                  ConnectionState.done &&
                              viewModel.hiveService
                                  .getCurrentUserProfile()
                                  .isSome()
                          ? viewModel.hiveService.getCurrentUserProfile().fold(
                                () => '',
                                (data) => data.profilePictureUrl,
                              )
                          : '',
                      placeholder: (context, url) =>
                          const FlutterLogo(size: 50),
                      errorWidget: (context, url, error) =>
                          const FlutterLogo(size: 50),
                      imageBuilder: (context, imageProvider) => CircleAvatar(
                        radius: kdSidebarAvatarShapeRadius,
                        backgroundImage: imageProvider,
                      ),
                    ),
                  ),
                );
              },
              items: [
                SidebarXItem(
                  icon: Icons.home,
                  label: ksSidebarHomeMenuText,
                  onTap: () async {
                    await viewModel.routerService.replaceWithHomeView();
                  },
                ),
                SidebarXItem(
                  icon: Icons.info,
                  label: ksSidebarAboutMenuText,
                  onTap: () async {
                    await viewModel.routerService.replaceWithAboutView();
                  },
                ),
                if (snapshot.connectionState == ConnectionState.done)
                  ...viewModel.hiveService.getCurrentUserProfile().isNone()
                      ? [
                          SidebarXItem(
                            icon: Icons.login_outlined,
                            label: ksSidebarLoginMenuText,
                            onTap: () async {
                              await viewModel.routerService
                                  .replaceWithLoginView();
                            },
                          ),
                          SidebarXItem(
                            icon: Icons.add_circle,
                            label: ksSidebarRegisterMenuText,
                            onTap: () async {
                              await viewModel.routerService
                                  .replaceWithRegisterView();
                            },
                          ),
                        ]
                      : [
                          SidebarXItem(
                            icon: Icons.logout,
                            label: ksSidebarLogoutMenuText,
                            onTap: () async {
                              await viewModel.hiveService
                                  .clearCurrentUserProfile();
                              await viewModel.routerService.navigateTo(
                                const HomeViewRoute(),
                              );
                            },
                          ),
                          SidebarXItem(
                            icon: Icons.people,
                            label: ksSidebarProfilesMenuText,
                            onTap: () async {
                              await viewModel.routerService
                                  .replaceWithProfilesView();
                            },
                          ),
                        ],
              ],
            );
          },
        );
      },
      viewModelBuilder: AppSidebarViewModel.new,
    );
  }
}