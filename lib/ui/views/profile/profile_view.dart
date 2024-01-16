import 'package:flutter/material.dart';
import 'package:midgard/services/hive_service.dart';
import 'package:midgard/ui/common/app_colors.dart';
import 'package:midgard/ui/common/app_constants.dart';
import 'package:midgard/ui/views/profile/profile_viewmodel.dart';
import 'package:midgard/ui/widgets/app_primitives/app_sidebar.dart';
import 'package:redacted/redacted.dart';
import 'package:stacked/stacked.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
      builder: (context, viewModel, child) => Scaffold(
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
      ),
      viewModelBuilder: ProfileViewModel.new,
    );
  }

  Widget _buildUsersGridView(
    BuildContext context,
    ProfileViewModel viewModel,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: viewModel.data!.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemBuilder: (context, index) {
        final user = viewModel.data![index];

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
                              child: ClipOval(
                                child: Image.memory(
                                  data,
                                  fit: BoxFit.fill,
                                ),
                              ),
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
}
