import 'package:badges/badges.dart' as badges;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flash/flash.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:midgard/app/app.router.dart';
import 'package:midgard/models/user/user_models.dart';
import 'package:midgard/models/validators/user_validators.dart';
import 'package:midgard/services/hive_service.dart';
import 'package:midgard/ui/common/app_colors.dart';
import 'package:midgard/ui/common/app_constants.dart';
import 'package:midgard/ui/common/app_strings.dart';
import 'package:midgard/ui/common/ui_helpers.dart';
import 'package:midgard/ui/views/single_profile/single_profile_view.form.dart';
import 'package:midgard/ui/views/single_profile/single_profile_viewmodel.dart';
import 'package:midgard/ui/widgets/app_primitives/app_error_widget.dart';
import 'package:midgard/ui/widgets/app_primitives/sidebar/app_sidebar.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

@FormView(
  fields: [
    FormTextField(
      name: 'username',
      validator: UserValidators.validateUsername,
    ),
    FormTextField(
      name: 'email',
      validator: UserValidators.validateEmail,
    ),
    FormTextField(
      name: 'fullname',
      validator: UserValidators.validateFullname,
    ),
    FormTextField(
      name: 'bio',
      validator: UserValidators.validateBio,
    ),
  ],
)
class SingleProfileView extends StackedView<SingleProfileViewModel>
    with $SingleProfileView {
  const SingleProfileView({
    @PathParam('userId') required this.userId,
    super.key,
  });

  final String userId;

  @override
  Widget builder(
    BuildContext context,
    SingleProfileViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      drawer: AppSidebar(
        controller: viewModel.sidebarController,
      ),
      backgroundColor: kcWhite,
      body: Row(
        children: [
          AppSidebar(
            controller: viewModel.sidebarController,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(
                kdSingleProfileViewPadding,
              ),
              child: Center(
                child: viewModel.busy(kbSingleProfileKey)
                    ? const CircularProgressIndicator()
                    : _buildProfileForm(context, viewModel),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileForm(
    BuildContext context,
    SingleProfileViewModel viewModel,
  ) {
    return viewModel.user.fold(
      () => AppErrorWidget(
        message: 'No user found with id: $userId',
      ),
      (user) => ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          scrollbars: false,
        ),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: kdSingleProfileViewMaxWidth,
            ),
            child: Column(
              children: [
                _buildAvatarPicker(
                  context,
                  viewModel,
                  user.profilePictureUrl,
                ),
                verticalSpaceLarge,
                _buildRolesChips(
                  context,
                  viewModel,
                  user.roles,
                ),
                verticalSpaceMedium,
                _buildUsernameField(
                  context,
                  viewModel,
                  user.username,
                ),
                if (viewModel.currentUser.userId == user.userId) ...[
                  verticalSpaceSmall,
                  _buildEmailField(
                    context,
                    viewModel,
                    user.email,
                  ),
                ],
                verticalSpaceSmall,
                _buildFullnameField(
                  context,
                  viewModel,
                  user.fullname ?? '',
                ),
                verticalSpaceSmall,
                _buildBioField(
                  context,
                  viewModel,
                  user.bio ?? '',
                ),
                if (viewModel.currentUser.userId == user.userId) ...[
                  verticalSpaceMedium,
                  _buildSubmitButton(
                    context,
                    viewModel,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarPicker(
    BuildContext context,
    SingleProfileViewModel viewModel,
    String profilePictureUrl,
  ) {
    return InkWell(
      onTap: () async {
        if (viewModel.currentUser.userId !=
            viewModel.user
                .map(
                  (user) => user.userId,
                )
                .getOrElse(() => '')) {
          return;
        }

        await viewModel.updateProfilePicture();
      },
      radius: kdSingleProfileViewAvatarShapeRadius,
      borderRadius: BorderRadius.circular(
        kdSingleProfileViewAvatarShapeRadius,
      ),
      child: badges.Badge(
        showBadge: viewModel.currentUser.userId ==
            viewModel.user
                .map(
                  (user) => user.userId,
                )
                .getOrElse(() => ''),
        position: badges.BadgePosition.bottomStart(),
        badgeContent: const Icon(
          Icons.edit,
          size: kdSingleProfileViewAvatarEditIconSize,
          color: kcWhite,
        ),
        badgeAnimation: const badges.BadgeAnimation.scale(
          animationDuration: Duration(
            seconds: kiSingleProfileViewAvatarEditBadgeAnimationDurationSec,
          ),
          colorChangeAnimationDuration: Duration(
            seconds:
                kiSingleProfileViewAvatarEditBadgeColorChangeAnimationDurationSec,
          ),
          curve: Curves.fastOutSlowIn,
          colorChangeAnimationCurve: Curves.easeInOut,
        ),
        badgeStyle: const badges.BadgeStyle(
          badgeColor: kcOrange,
        ),
        child: viewModel.profilePicture.fold(
          () => CachedNetworkImage(
            imageUrl: profilePictureUrl,
            placeholder: (context, url) => const FlutterLogo(
              size: kdSingleProfileViewAvatarShapeRadius,
            ),
            errorWidget: (context, url, error) => const FlutterLogo(
              size: kdSingleProfileViewAvatarShapeRadius,
            ),
            imageBuilder: (context, imageProvider) => CircleAvatar(
              radius: kdSingleProfileViewAvatarShapeRadius,
              backgroundImage: imageProvider,
            ),
          ),
          (data) => CircleAvatar(
            radius: kdSingleProfileViewAvatarShapeRadius,
            backgroundImage: MemoryImage(data.bytes),
          ),
        ),
      ),
    );
  }

  Widget _buildUsernameField(
    BuildContext context,
    SingleProfileViewModel viewModel,
    String username,
  ) {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(
            hintText: 'Username',
            contentPadding: EdgeInsets.all(kdSingleProfileViewNameFieldPadding),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            focusedBorder: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kcLightGrey),
              borderRadius: BorderRadius.all(
                Radius.circular(kdSingleProfileViewFieldBorderRadius),
              ),
            ),
          ),
          focusNode: usernameFocusNode,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          controller: usernameController,
          readOnly: viewModel.currentUser.userId !=
              viewModel.user
                  .map(
                    (user) => user.userId,
                  )
                  .getOrElse(() => ''),
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
        if (viewModel.hasUsernameValidationMessage) ...[
          verticalSpaceTiny,
          Text(
            viewModel.usernameValidationMessage!,
            style: const TextStyle(
              color: kcRed,
              fontSize: kdSingleProfileViewUsernameFieldValidationTextSize,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildEmailField(
    BuildContext context,
    SingleProfileViewModel viewModel,
    String email,
  ) {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(
            hintText: 'Email',
            contentPadding:
                EdgeInsets.all(kdSingleProfileViewEmailFieldPadding),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            focusedBorder: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kcLightGrey),
              borderRadius: BorderRadius.all(
                Radius.circular(kdSingleProfileViewFieldBorderRadius),
              ),
            ),
          ),
          focusNode: emailFocusNode,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          controller: emailController,
          readOnly: viewModel.currentUser.userId !=
              viewModel.user
                  .map(
                    (user) => user.userId,
                  )
                  .getOrElse(() => ''),
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
        if (viewModel.hasEmailValidationMessage) ...[
          verticalSpaceTiny,
          Text(
            viewModel.emailValidationMessage!,
            style: const TextStyle(
              color: kcRed,
              fontSize: kdSingleProfileViewEmailFieldValidationTextSize,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFullnameField(
    BuildContext context,
    SingleProfileViewModel viewModel,
    String fullname,
  ) {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(
            hintText: 'Fullname',
            contentPadding:
                EdgeInsets.all(kdSingleProfileViewFullnameFieldPadding),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            focusedBorder: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kcLightGrey),
              borderRadius: BorderRadius.all(
                Radius.circular(kdSingleProfileViewFieldBorderRadius),
              ),
            ),
          ),
          focusNode: fullnameFocusNode,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          controller: fullnameController,
          readOnly: viewModel.currentUser.userId !=
              viewModel.user
                  .map(
                    (user) => user.userId,
                  )
                  .getOrElse(() => ''),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          maxLength: kMaxFullnameLength,
        ),
        if (viewModel.hasFullnameValidationMessage) ...[
          verticalSpaceTiny,
          Text(
            viewModel.fullnameValidationMessage!,
            style: const TextStyle(
              color: kcRed,
              fontSize: kdSingleProfileViewFullnameFieldValidationTextSize,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildBioField(
    BuildContext context,
    SingleProfileViewModel viewModel,
    String bio,
  ) {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(
            hintText: 'Bio',
            contentPadding: EdgeInsets.all(kdSingleProfileViewBioFieldPadding),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            focusedBorder: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kcLightGrey),
              borderRadius: BorderRadius.all(
                Radius.circular(kdSingleProfileViewFieldBorderRadius),
              ),
            ),
          ),
          focusNode: bioFocusNode,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          controller: bioController,
          readOnly: viewModel.currentUser.userId !=
              viewModel.user
                  .map(
                    (user) => user.userId,
                  )
                  .getOrElse(() => ''),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          maxLength: kMaxBioLength,
        ),
        if (viewModel.hasBioValidationMessage) ...[
          verticalSpaceTiny,
          Text(
            viewModel.bioValidationMessage!,
            style: const TextStyle(
              color: kcRed,
              fontSize: kdSingleProfileViewBioFieldValidationTextSize,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildRolesChips(
    BuildContext context,
    SingleProfileViewModel viewModel,
    List<UserRole> roles,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...UserRole.values.map(
          (role) {
            if (!roles.contains(role) &&
                (role != UserRole.proposer || !viewModel.currentUser.isAdmin)) {
              return const SizedBox.shrink();
            }

            return _buildRoleChip(
              context,
              viewModel,
              role,
            );
          },
        ),
      ],
    );
  }

  Widget _buildRoleChip(
    BuildContext context,
    SingleProfileViewModel viewModel,
    UserRole role,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: kdSingleProfileViewRoleBadgePadding,
      ),
      child: Chip(
        deleteIcon: CircleAvatar(
          backgroundColor:
              viewModel.currentUser.isAdmin && role == UserRole.proposer
                  ? viewModel.user
                      .map(
                        (user) => user.isProposer ? kcRed : kcOrange,
                      )
                      .getOrElse(() => role.color)
                  : role.color,
          child: Icon(
            viewModel.currentUser.isAdmin && role == UserRole.proposer
                ? viewModel.user
                    .map(
                      (user) => user.isProposer ? Icons.remove : Icons.add,
                    )
                    .getOrElse(() => Icons.verified)
                : Icons.verified,
            color: kcWhite,
            size: kdSingleProfileViewRoleEditIconSize,
          ),
        ),
        deleteButtonTooltipMessage:
            viewModel.currentUser.isAdmin && role == UserRole.proposer
                ? viewModel.user
                    .map(
                      (user) => user.isProposer ? 'Remove role' : 'Add role',
                    )
                    .getOrElse(() => 'Role verified')
                : 'Role verified',
        onDeleted: () async {
          if (viewModel.currentUser.isAdmin &&
              role == UserRole.proposer &&
              viewModel.user.isSome()) {
            final isProposer = viewModel.user
                .map(
                  (user) => user.isProposer,
                )
                .getOrElse(() => false);

            if (isProposer) {
              await viewModel.removeRole(role);
            } else {
              await viewModel.addRole(role);
            }
          }
        },
        side: BorderSide(
          color: role.color,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            kdSingleProfileViewRoleBadgeShapeRadius,
          ),
        ),
        label: Text(
          role.value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: role.color,
      ),
    );
  }

  Widget _buildSubmitButton(
    BuildContext context,
    SingleProfileViewModel viewModel,
  ) {
    return ElevatedButton(
      onPressed: () async {
        await viewModel.updateUser();

        if (!context.mounted) return;

        if (viewModel.hasErrorForKey(kbSingleProfileKey)) {
          await context.showErrorBar(
            position: FlashPosition.top,
            indicatorColor: kcRed,
            content: Text(
              viewModel.error(kbSingleProfileKey).message as String,
            ),
            primaryActionBuilder: (context, controller) {
              return IconButton(
                onPressed: controller.dismiss,
                icon: const Icon(Icons.close),
              );
            },
          );
        } else {
          await context.showSuccessBar(
            position: FlashPosition.top,
            indicatorColor: kcGreen,
            content: const Text('Profile updated successfully!'),
            primaryActionBuilder: (context, controller) {
              return IconButton(
                onPressed: controller.dismiss,
                icon: const Icon(Icons.close),
              );
            },
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: kcOrange,
        minimumSize: const Size(
          kdSingleProfileViewMaxWidth / 2,
          kdSingleProfileViewSubmitButtonMinHeight,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: kdSingleProfileViewSubmitButtonPadding,
          vertical: kdSingleProfileViewSubmitButtonPadding,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            kdSingleProfileViewSubmitButtonShapeRadius,
          ),
        ),
      ),
      child: const Text(
        'Update',
        style: TextStyle(
          color: kcWhite,
          fontSize: KdSingleProfileViewSubmitButtonTextSize,
        ),
      ),
    );
  }

  @override
  Future<void> onViewModelReady(SingleProfileViewModel viewModel) async {
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
  SingleProfileViewModel viewModelBuilder(BuildContext context) =>
      SingleProfileViewModel(userId: userId);

  @override
  void onDispose(SingleProfileViewModel viewModel) {
    super.onDispose(viewModel);

    disposeForm();
    viewModel.sidebarController.dispose();
  }
}
