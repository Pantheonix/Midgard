import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:midgard/ui/common/app_colors.dart';
import 'package:midgard/ui/common/app_constants.dart';
import 'package:midgard/ui/common/ui_helpers.dart';
import 'package:midgard/ui/views/profiles/profiles_view.form.dart';
import 'package:midgard/ui/views/profiles/profiles_viewmodel.dart';
import 'package:midgard/ui/widgets/app_primitives/sidebar/app_sidebar.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

@FormView(
  fields: [
    FormTextField(name: 'name'),
    FormTextField(name: 'email'),
    FormDropdownField(
      name: 'sortBy',
      items: [
        StaticDropdownItem(
          title: 'Name Asc',
          value: 'NameAsc',
        ),
        StaticDropdownItem(
          title: 'Name Desc',
          value: 'NameDesc',
        ),
        StaticDropdownItem(
          title: 'Email Asc',
          value: 'EmailAsc',
        ),
        StaticDropdownItem(
          title: 'Email Desc',
          value: 'EmailDesc',
        ),
      ],
    ),
    FormTextField(name: 'page'),
    FormTextField(name: 'pageSize'),
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
                    else
                      _buildUsersGridView(context, viewModel),
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
        _buildFilterNameField(viewModel),
        horizontalSpaceSmall,
        _buildFilterEmailField(viewModel),
        horizontalSpaceSmall,
        _buildFilterSortByField(viewModel),
        horizontalSpaceSmall,
        _buildFilterPageField(viewModel),
        horizontalSpaceSmall,
        _buildFilterLimitField(viewModel),
        horizontalSpaceSmall,
        IconButton(
          icon: const Icon(Icons.filter_list),
          onPressed: () {
            viewModel.reinitialize();
          },
        ),
      ],
    );
  }

  Widget _buildFilterNameField(
    ProfilesViewModel viewModel,
  ) {
    return Expanded(
      child: TextFormField(
        decoration: const InputDecoration(
          hintText: 'Name',
          contentPadding: EdgeInsets.all(kdProfilesViewNameFieldPadding),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          focusedBorder: UnderlineInputBorder(),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: kcLightGrey),
          ),
        ),
        focusNode: nameFocusNode,
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.next,
        controller: nameController,
      ),
    );
  }

  Widget _buildFilterEmailField(
    ProfilesViewModel viewModel,
  ) {
    return Expanded(
      child: TextFormField(
        decoration: const InputDecoration(
          hintText: 'Email',
          contentPadding: EdgeInsets.all(kdProfilesViewEmailFieldPadding),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          focusedBorder: UnderlineInputBorder(),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: kcLightGrey),
          ),
        ),
        focusNode: emailFocusNode,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        controller: emailController,
      ),
    );
  }

  Widget _buildFilterSortByField(
    ProfilesViewModel viewModel,
  ) {
    return Expanded(
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          hintText: 'Sort By',
          contentPadding: EdgeInsets.all(kdProfilesViewSortByFieldPadding),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          focusedBorder: UnderlineInputBorder(),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: kcLightGrey),
          ),
        ),
        items: const [
          DropdownMenuItem(
            value: 'NameAsc',
            child: Text('Name Asc'),
          ),
          DropdownMenuItem(
            value: 'NameDesc',
            child: Text('Name Desc'),
          ),
          DropdownMenuItem(
            value: 'EmailAsc',
            child: Text('Email Asc'),
          ),
          DropdownMenuItem(
            value: 'EmailDesc',
            child: Text('Email Desc'),
          ),
        ],
        onChanged: (String? value) {
          if (value != null) {
            viewModel.setSortBy(value);
          }
        },
      ),
    );
  }

  Widget _buildFilterPageField(
    ProfilesViewModel viewModel,
  ) {
    return Expanded(
      child: TextFormField(
        decoration: const InputDecoration(
          hintText: 'Page',
          contentPadding: EdgeInsets.all(kdProfilesViewPageFieldPadding),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          focusedBorder: UnderlineInputBorder(),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: kcLightGrey),
          ),
        ),
        focusNode: pageFocusNode,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        controller: pageController,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
      ),
    );
  }

  Widget _buildFilterLimitField(
    ProfilesViewModel viewModel,
  ) {
    return Expanded(
      child: TextFormField(
        decoration: const InputDecoration(
          hintText: 'Page Size',
          contentPadding: EdgeInsets.all(kdProfilesViewPageSizeFieldPadding),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          focusedBorder: UnderlineInputBorder(),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: kcLightGrey),
          ),
        ),
        focusNode: pageSizeFocusNode,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        controller: pageSizeController,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
      ),
    );
  }

  Widget _buildUsersGridView(
    BuildContext context,
    ProfilesViewModel viewModel,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: viewModel.users.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: kiProfilesViewUsersGridCrossAxisCount,
      ),
      itemBuilder: (context, index) {
        final user = viewModel.users[index];

        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CachedNetworkImage(
              imageUrl: user.profilePictureUrl,
              placeholder: (context, url) => const FlutterLogo(size: 50),
              errorWidget: (context, url, error) => const FlutterLogo(size: 50),
              imageBuilder: (context, imageProvider) => CircleAvatar(
                radius: kdProfilesViewUserListAvatarShapeRadius,
                backgroundImage: imageProvider,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(
                kdProfilesViewAvatarUsernamePadding,
              ),
              child: Text(
                user.username,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void onViewModelReady(ProfilesViewModel viewModel) {
    super.onViewModelReady(viewModel);

    syncFormWithViewModel(viewModel);
    viewModel.reinitialize();
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