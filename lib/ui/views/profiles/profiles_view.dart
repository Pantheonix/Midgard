import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:midgard/app/app.router.dart';
import 'package:midgard/models/user/user_models.dart';
import 'package:midgard/services/hive_service.dart';
import 'package:midgard/ui/common/app_colors.dart';
import 'package:midgard/ui/common/app_constants.dart';
import 'package:midgard/ui/common/app_strings.dart';
import 'package:midgard/ui/common/ui_helpers.dart';
import 'package:midgard/ui/views/profiles/profiles_view.form.dart';
import 'package:midgard/ui/views/profiles/profiles_viewmodel.dart';
import 'package:midgard/ui/widgets/app_primitives/sidebar/app_sidebar.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

@FormView(
  fields: [
    FormTextField(name: 'username'),
  ],
)
class ProfilesView extends StackedView<ProfilesViewModel> with $ProfilesView {
  const ProfilesView({super.key});

  @override
  Widget builder(
    BuildContext context,
    ProfilesViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      drawer: AppSidebar(
        controller: viewModel.sidebarController,
      ),
      backgroundColor: kcWhite,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSidebar(
            controller: viewModel.sidebarController,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: kdProfilesViewPadding,
                ),
                child: Column(
                  children: [
                    _buildFormHeader(viewModel),
                    verticalSpaceMedium,
                    if (viewModel.busy(kbProfilesKey))
                      const Center(
                        child: CircularProgressIndicator(),
                      )
                    else ...[
                      _buildUsersTable(context, viewModel),
                      verticalSpaceMedium,
                      _buildPaginationFooter(context, viewModel),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormHeader(
    ProfilesViewModel viewModel,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildFilterUsernameField(viewModel),
        horizontalSpaceSmall,
        IconButton(
          icon: const Icon(Icons.filter_list),
          onPressed: () {
            viewModel.init();
          },
        ),
      ],
    );
  }

  Widget _buildFilterUsernameField(
    ProfilesViewModel viewModel,
  ) {
    return Expanded(
      child: TextFormField(
        decoration: const InputDecoration(
          hintText: 'Username',
          contentPadding: EdgeInsets.all(kdProfilesViewNameFieldPadding),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          focusedBorder: UnderlineInputBorder(),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: kcLightGrey),
          ),
        ),
        focusNode: usernameFocusNode,
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.next,
        controller: usernameController,
      ),
    );
  }

  Widget _buildUsersTable(
    BuildContext context,
    ProfilesViewModel viewModel,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: constraints.maxWidth),
          child: DataTable(
            sortColumnIndex: 1,
            sortAscending: viewModel.sortByValue == SortUsersBy.nameAsc,
            showCheckboxColumn: false,
            columns: [
              const DataColumn(
                label: Text(
                  'Avatar',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: kdProfilesViewDataColumnTitleFontSize,
                  ),
                ),
              ),
              DataColumn(
                label: const Text(
                  'Username',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: kdProfilesViewDataColumnTitleFontSize,
                  ),
                ),
                onSort: (int columnIndex, bool ascending) {
                  viewModel
                    ..sortByValue =
                        ascending ? SortUsersBy.nameAsc : SortUsersBy.nameDesc
                    ..init();
                },
              ),
              const DataColumn(
                label: Text(
                  'Roles',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: kdProfilesViewDataColumnTitleFontSize,
                  ),
                ),
              ),
            ],
            rows: List<DataRow>.generate(
              viewModel.users.length,
              (int index) {
                final user = viewModel.users[index];
                return DataRow(
                  selected: viewModel.selectedIndex == index,
                  onSelectChanged: (bool? selected) {
                    if (selected != null && selected) {
                      viewModel.selectedIndex = index;
                      viewModel.routerService.replaceWithSingleProfileView(
                        userId: user.userId,
                      );
                    }
                  },
                  cells: [
                    DataCell(
                      CachedNetworkImage(
                        imageUrl: user.profilePictureUrl,
                        placeholder: (context, url) => const FlutterLogo(
                          size: kdProfilesViewUserListAvatarShapeRadius,
                        ),
                        errorWidget: (context, url, error) => const FlutterLogo(
                          size: kdProfilesViewUserListAvatarShapeRadius,
                        ),
                        imageBuilder: (context, imageProvider) => CircleAvatar(
                          radius: kdProfilesViewUserListAvatarShapeRadius,
                          backgroundImage: imageProvider,
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        user.username,
                      ),
                    ),
                    DataCell(
                      Text(
                        user.roles.value,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaginationFooter(
    BuildContext context,
    ProfilesViewModel viewModel,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            if (viewModel.pageValue == 1) {
              return;
            }

            viewModel
              ..pageValue = viewModel.pageValue - 1
              ..init();
          },
        ),
        horizontalSpaceMedium,
        Text(
          '${viewModel.pageValue} / ${(viewModel.count / kiProfilesViewPageSize).ceil()}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        horizontalSpaceMedium,
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () {
            if (viewModel.pageValue ==
                (viewModel.count / kiProfilesViewPageSize).ceil()) {
              return;
            }

            viewModel
              ..pageValue = viewModel.pageValue + 1
              ..init();
          },
        ),
      ],
    );
  }

  @override
  Future<void> onViewModelReady(ProfilesViewModel viewModel) async {
    super.onViewModelReady(viewModel);

    final userProfileBox = await HiveService.userProfileBoxAsync;
    if (viewModel.hiveService.getCurrentUserProfile(userProfileBox).isNone()) {
      await viewModel.routerService.replaceWithHomeView(
        warningMessage: ksAppNotLoggedInRedirectMessage,
      );
    }

    syncFormWithViewModel(viewModel);
    await viewModel.init();
  }

  @override
  ProfilesViewModel viewModelBuilder(BuildContext context) =>
      ProfilesViewModel();

  @override
  void onDispose(ProfilesViewModel viewModel) {
    super.onDispose(viewModel);

    disposeForm();
    viewModel.sidebarController.dispose();
  }
}
