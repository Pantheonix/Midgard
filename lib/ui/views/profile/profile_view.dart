import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:midgard/services/hive_service.dart';
import 'package:midgard/ui/common/app_colors.dart';
import 'package:midgard/ui/common/app_constants.dart';
import 'package:midgard/ui/common/ui_helpers.dart';
import 'package:midgard/ui/views/profile/profile_view.form.dart';
import 'package:midgard/ui/views/profile/profile_viewmodel.dart';
import 'package:midgard/ui/widgets/app_primitives/app_sidebar.dart';
import 'package:redacted/redacted.dart';
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
    FormTextField(name: 'limit'),
  ],
)
class ProfileView extends StackedView<ProfileViewModel> with $ProfileView {
  const ProfileView({super.key});

  @override
  Widget builder(
    BuildContext context,
    ProfileViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      drawer: AppSidebar(
        controller: viewModel.sidebarController,
        routerService: viewModel.routerService,
        hiveService: viewModel.hiveService,
      ),
      backgroundColor: kcWhite,
      body: Row(
        children: [
          AppSidebar(
            controller: viewModel.sidebarController,
            routerService: viewModel.routerService,
            hiveService: viewModel.hiveService,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: kdProfileViewPadding,
                ),
                child: Column(
                  children: [
                    _buildFormHeader(viewModel),
                    if (viewModel.isBusy)
                      const CircularProgressIndicator()
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
    ProfileViewModel viewModel,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildFilterNameField(viewModel),
        horizontalSpaceTiny,
        _buildFilterEmailField(viewModel),
        horizontalSpaceTiny,
        _buildFilterSortByField(viewModel),
        horizontalSpaceTiny,
        _buildFilterPageField(viewModel),
        horizontalSpaceTiny,
        _buildFilterLimitField(viewModel),
        horizontalSpaceTiny,
        IconButton(
          icon: const Icon(Icons.filter_list),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildFilterNameField(
    ProfileViewModel viewModel,
  ) {
    return Expanded(
      child: TextFormField(
        decoration: const InputDecoration(
          hintText: 'Name',
        ),
        focusNode: nameFocusNode,
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.next,
        controller: nameController,
      ),
    );
  }

  Widget _buildFilterEmailField(
    ProfileViewModel viewModel,
  ) {
    return Expanded(
      child: TextFormField(
        decoration: const InputDecoration(
          hintText: 'Email',
        ),
        focusNode: emailFocusNode,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        controller: emailController,
      ),
    );
  }

  Widget _buildFilterSortByField(
    ProfileViewModel viewModel,
  ) {
    return Expanded(
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          hintText: 'Sort By',
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
        onChanged: (String? value) {},
      ),
    );
  }

  Widget _buildFilterPageField(
    ProfileViewModel viewModel,
  ) {
    return Expanded(
      child: TextFormField(
        decoration: const InputDecoration(
          hintText: 'Page',
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
    ProfileViewModel viewModel,
  ) {
    return Expanded(
      child: TextFormField(
        decoration: const InputDecoration(
          hintText: 'Limit',
        ),
        focusNode: limitFocusNode,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        controller: limitController,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
      ),
    );
  }

  Widget _buildUsersGridView(
    BuildContext context,
    ProfileViewModel viewModel,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: viewModel.users.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemBuilder: (context, index) {
        final user = viewModel.users[index];

        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              FutureBuilder(
                future: HiveService.avatarDataBox,
                builder: (context, snapshot) {
                  return snapshot.connectionState == ConnectionState.done
                      ? viewModel.hiveService
                          .getUserAvatarBlob(user.userId)
                          .fold(
                            () => const FlutterLogo(size: 50).redacted(
                              context: context,
                              redact: true,
                            ),
                            (data) => CircleAvatar(
                              radius: kdUserListAvatarShapeRadius,
                              backgroundImage: MemoryImage(data),
                            ),
                          )
                      : const FlutterLogo(size: 50).redacted(
                          context: context,
                          redact: true,
                        );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  user.username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void onViewModelReady(ProfileViewModel viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.initialise();
  }

  @override
  ProfileViewModel viewModelBuilder(BuildContext context) => ProfileViewModel();

  @override
  void onDispose(ProfileViewModel viewModel) {
    super.onDispose(viewModel);
    viewModel.sidebarController.dispose();
  }
}
