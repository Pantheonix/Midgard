/// The max width the content can ever take up on the screen
const double kdDesktopMaxContentWidth = 1150;

// The max height the home view will take up
const double kdDesktopMaxContentHeight = 750;

// title text font size for desktop
const double kdDesktopTitleTextSize = 24;

// subtitle text font size for desktop
const double kdDesktopSubtitleTextSize = 14;

// busy keys
const String kbLoginKey = 'login';
const String kbRegisterKey = 'register';
const String kbProfilesKey = 'profile';
const String kbSingleProfileKey = 'singleProfile';
const String kbProblemsKey = 'problems';
const String kbSingleProblemKey = 'singleProblem';
const String kbProblemProposalsKey = 'problemProposals';
const String kbSingleProblemProposalKey = 'singleProblemProposal';
const String kbCreateProposalDashboardKey = 'createProposalDashboard';
const String kbUpdateProposalDashboardKey = 'updateProposalDashboard';
const String kbAddTestKey = 'addTest';
const String kbUpdateTestKey = 'updateTest';
const String kbDeleteTestKey = 'deleteTest';
const String kbPublishProblemKey = 'publishProblem';
const String kbSendSubmissionKey = 'sendSubmission';

// validation constants
const int kMinUsernameLength = 3;
const kEmailRegex = r'^[\w\-\.]+@([\w-]+\.)+[\w-]{2,4}$';
const int kMinPasswordLength = 6;
const int kMaxPasswordLength = 20;
const kPasswordRegex =
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^\da-zA-Z]).{6,20}$';
const int kMaxFullnameLength = 50;
const int kMaxBioLength = 300;
const int kMaxProfilePictureSize = 10000000;
const List<String> kAllowedProfilePictureTypes = [
  'jpeg',
  'png',
  'jpg',
];
const List<String> kAllowedTestArchiveTypes = [
  'zip',
];

const int kMinProblemNameLength = 2;
const int kMaxProblemNameLength = 128;
const int kMinProblemBriefLength = 4;
const int kMaxProblemBriefLength = 256;
const int kMinProblemDescriptionLength = 16;
const int kMaxProblemDescriptionLength = 4096;
const int kMinProblemSourceNameLength = 2;
const int kMaxProblemSourceNameLength = 128;
const int kMinProblemAuthorNameLength = 2;
const int kMaxProblemAuthorNameLength = 128;
const double kMinProblemTimeLimit = 0.1;
const double kMaxProblemTimeLimit = 5;
const double kMinProblemTotalMemoryLimit = 0.1;
const double kMaxProblemTotalMemoryLimit = 512;
const double kMinProblemStackMemoryLimit = 0.1;
const double kMaxProblemStackMemoryLimit = 64;
const int kMaxProblemNumberOfTests = 20;
const int kMinProblemTestScore = 0;
const int kMaxProblemTestScore = 100;
const int kMaxProblemTotalTestsScore = 100;
const int kMaxProblemTestArchiveSize = 1000000;
const kLimitDecimalRegex = r'^\d+\.?\d?';

const int kMaxSubmissionSourceCodeSize = 10000;

// placeholders
const String kRiveMoveEyesPadding = '--------------------------';

// assets
const String ksAssetAboutBackgroundImage = 'assets/images/papyrus.jpg';

// rive
const String ksRiveBearPath = 'assets/rive/bear.riv';
const String ksRiveBearStateMachineName = 'Login Machine';
const String ksRiveBearIsCheckingInputName = 'isChecking';
const String ksRiveBearIsHandsUpInputName = 'isHandsUp';
const String ksRiveBearTrigSuccessInputName = 'trigSuccess';
const String ksRiveBearTrigFailInputName = 'trigFail';
const String ksRiveBearNumLookInputName = 'numLook';

// login view
const double kdLoginViewClipperHeight = 550;
const double kdLoginViewRiveAnimationHeightPercentage = 0.3;
const double kdLoginViewFormContainerPadding = 24;
const double kdLoginViewSendButtonWidth = double.infinity;
const double kdLoginViewSendButtonHeight = 44;

const String ksLoginViewFormHeaderText = 'Login';
const double kdLoginViewFormHeaderTextSize = 32;

const double kdLoginViewEmailFieldTextSize = 14;
const double kdLoginViewEmailFieldPadding = 12;
const String ksLoginViewEmailFieldLabelText = 'Email';
const double kdLoginViewEmailFieldLabelTextSize = 14;
const String ksLoginViewEmailFieldExtraText = ' *';

const double kdLoginViewPasswordFieldTextSize = 14;
const double kdLoginViewPasswordFieldPadding = 12;
const String ksLoginViewPasswordFieldLabelText = 'Password';
const double kdLoginViewPasswordFieldLabelTextSize = 14;
const String ksLoginViewPasswordFieldExtraText = ' *';
const double kdLoginViewPasswordFieldSuffixIconSize = 14;

const int kiLoginViewSnackbarDuration = 4;
const String ksLoginViewSnackbarDismissText = 'Dismiss';
const double kdLoginViewSnackbarDismissTextSize = 10;
const double kdLoginViewSnackbarShapeRadius = 10;
const String ksLoginViewSnackbarTitleText = 'Login failed';
const double kdLoginViewSnackbarTitleTextSize = 10;

const double kdLoginViewSendButtonLoadingIndicatorWidth = 24;
const double kdLoginViewSendButtonLoadingIndicatorHeight = 24;
const double kdLoginViewSendButtonLoadingIndicatorPadding = 2;
const double kdLoginViewSendButtonLoadingIndicatorStrokeWidth = 3;
const String ksLoginViewSendButtonText = 'Login';
const double kdLoginViewSendButtonTextSize = 16;
const double kdLoginViewSendButtonShapeRadius = 10;

const String ksLoginViewFormFooterText = 'Don\'t have an account?';
const double kdLoginViewFormFooterTextSize = 14;
const String ksLoginViewFormFooterLinkText = ' Register now!';

// register view
const double kdRegisterViewClipperHeight = 550;
const double kdRegisterViewRiveAnimationHeightPercentage = 0.3;
const double kdRegisterViewFormContainerPadding = 24;
const double kdRegisterViewSendButtonWidth = double.infinity;
const double kdRegisterViewSendButtonHeight = 44;

const String ksRegisterViewFormHeaderText = 'Register';
const double kdRegisterViewFormHeaderTextSize = 32;

const double kdRegisterViewUsernameFieldTextSize = 14;
const double kdRegisterViewUsernameFieldPadding = 12;
const String ksRegisterViewUsernameFieldLabelText = 'Username';
const double kdRegisterViewUsernameFieldLabelTextSize = 14;
const String ksRegisterViewUsernameFieldExtraText = ' *';
const double KdRegisterViewUsernameFieldValidationTextSize = 12;

const double kdRegisterViewEmailFieldTextSize = 14;
const double kdRegisterViewEmailFieldPadding = 12;
const String ksRegisterViewEmailFieldLabelText = 'Email';
const double kdRegisterViewEmailFieldLabelTextSize = 14;
const String ksRegisterViewEmailFieldExtraText = ' *';
const double KdRegisterViewEmailFieldValidationTextSize = 12;

const double kdRegisterViewPasswordFieldTextSize = 14;
const double kdRegisterViewPasswordFieldPadding = 12;
const String ksRegisterViewPasswordFieldLabelText = 'Password';
const double kdRegisterViewPasswordFieldLabelTextSize = 14;
const String ksRegisterViewPasswordFieldExtraText = ' *';
const double kdRegisterViewPasswordFieldSuffixIconSize = 14;
const double KdRegisterViewPasswordFieldValidationTextSize = 12;

const double kdRegisterViewConfirmPasswordFieldTextSize = 14;
const double kdRegisterViewConfirmPasswordFieldPadding = 12;
const String ksRegisterViewConfirmPasswordFieldLabelText = 'Confirm password';
const double kdRegisterViewConfirmPasswordFieldLabelTextSize = 14;
const String ksRegisterViewConfirmPasswordFieldExtraText = ' *';
const double kdRegisterViewConfirmPasswordFieldSuffixIconSize = 14;

const int kiRegisterViewSnackbarDuration = 4;
const String ksRegisterViewSnackbarDismissText = 'Dismiss';
const double kdRegisterViewSnackbarDismissTextSize = 10;
const double kdRegisterViewSnackbarShapeRadius = 10;
const String ksRegisterViewSnackbarTitleText = 'Register failed';
const double kdRegisterViewSnackbarTitleTextSize = 10;

const double kdRegisterViewSendButtonLoadingIndicatorWidth = 24;
const double kdRegisterViewSendButtonLoadingIndicatorHeight = 24;
const double kdRegisterViewSendButtonLoadingIndicatorPadding = 2;
const double kdRegisterViewSendButtonLoadingIndicatorStrokeWidth = 3;
const String ksRegisterViewSendButtonText = 'Register';
const double kdRegisterViewSendButtonTextSize = 16;
const double kdRegisterViewSendButtonShapeRadius = 10;

const String ksRegisterViewFormFooterText = 'Already have an account?';
const double kdRegisterViewFormFooterTextSize = 14;
const String ksRegisterViewFormFooterLinkText = ' Login now!';

// home view
const double kdHomeViewPadding = 20;
const double kdHomeViewTitleTextSize = 20;
const double kdHomeViewSubtitleTextSize = 14;
const double kdHomeViewWarningIconSize = 40;
const double kdHomeViewWarningBadgeIconSize = 10;
const double kdHomeViewWarningIconPadding = 8;
const int kiHomeViewWarningBadgeAnimationDurationSec = 2;
const int kiHomeViewWarningBadgeColorChangeAnimationDurationSec = 1;

// about view
const double kdAboutViewPadding = 20;
const double kdAboutViewTextSize = 15;
const double kdAboutViewTextLetterSpacing = 1;
const double kdAboutViewTextPadding = 15;

// profiles view
const double kdProfilesViewDataColumnTitleFontSize = 16;
const double kdProfilesViewPadding = 20;
const double kdProfilesViewUserListAvatarShapeRadius = 20;
const double kdProfilesViewNameFieldPadding = 10;
const double kdProfilesViewEmailFieldPadding = 10;
const double kdProfilesViewSortByFieldPadding = 10;
const double kdProfilesViewPageFieldPadding = 10;
const double kdProfilesViewPageSizeFieldPadding = 10;
const double kdProfilesViewAvatarUsernamePadding = 8;
const int kiProfilesViewUsersGridCrossAxisCount = 4;
const int kiProfilesViewPageSize = 10;

// single profile view
const double kdSingleProfileViewPadding = 20;
const double kdSingleProfileViewAvatarShapeRadius = 100;
const double kdSingleProfileViewMaxWidth = 600;
const double kdSingleProfileViewNameFieldPadding = 10;
const double kdSingleProfileViewEmailFieldPadding = 10;
const double kdSingleProfileViewFullnameFieldPadding = 10;
const double kdSingleProfileViewBioFieldPadding = 10;
const double kdSingleProfileViewRoleBadgePadding = 5;
const double kdSingleProfileViewRoleBadgeShapeRadius = 50;
const double kdSingleProfileViewFieldBorderRadius = 20;
const double kdSingleProfileViewAvatarEditIconSize = 33;
const int kiSingleProfileViewAvatarEditBadgeAnimationDurationSec = 1;
const int kiSingleProfileViewAvatarEditBadgeColorChangeAnimationDurationSec = 1;
const double kdSingleProfileViewRoleEditIconSize = 20;
const double kdSingleProfileViewSubmitButtonPadding = 10;
const double kdSingleProfileViewSubmitButtonShapeRadius = 30;
const double KdSingleProfileViewSubmitButtonTextSize = 18;
const double kdSingleProfileViewSubmitButtonMinHeight = 44;

const double kdSingleProfileViewUsernameFieldValidationTextSize = 12;
const double kdSingleProfileViewEmailFieldValidationTextSize = 12;
const double kdSingleProfileViewFullnameFieldValidationTextSize = 12;
const double kdSingleProfileViewBioFieldValidationTextSize = 12;

// problems view
const double kdProblemsViewPadding = 20;
const int kiProblemsViewPageSize = 10;
const double kdProblemsViewProblemsListUserAvatarShapeRadius = 20;
const double kdProblemsViewProblemsListUsernameFontSize = 10;
const double kdProblemsViewProblemsListTitleFontSize = 20;
const double kdProblemsViewProblemsListSubtitleFontSize = 14;
const int kiProblemsViewProblemsListSubtitleMaxLines = 3;
const double kdProblemsViewProblemsListTileVisualVerticalDensity = 4;
const double kdProblemsViewProblemsListTileHeight = 150;
const double kdProblemsViewProblemsListTilePadding = 10;
const double kdProblemsViewProblemsListTileBorderWidth = 20;
const String ksProblemsViewProblemsListTileForegroundKey = 'foreground';
const String ksProblemsViewProblemsListTileBackgroundKey = 'background';
const double kdProblemsViewProblemsListTileBackgroundLeadingIconSize = 40;
const double kdProblemsViewProblemsListTileBackgroundTitleFontSize = 15;
const double
    kdProblemsViewProblemsListTileBackgroundLeadingAndTrailingFontSize = 13;
const double kdProblemsViewProblemsListTileElevation = 6;
const int kiHoverDurationMs = 600;

// single problem view
const double kdSingleProblemViewPadding = 20;
const double kdSingleProblemViewDataColumnTitleFontSize = 16;
const double kdSingleProblemViewProposerAvatarShapeRadius = 20;
const double kdSingleProblemViewProposerUsernameFontSize = 10;
const double kdSingleProblemViewDataTableBorderRadius = 10;
const double kdSingleProblemViewDataTableBorderWidth = 1.5;
const double kdSingleProblemViewTitleFontSize = 20;
const double kdSingleProblemViewDescriptionPadding = 10;

// problem proposals view

// single problem proposal view

// create proposal dashboard view
const double kdCreateProposalDashboardViewPadding = 20;
const double kdCreateProposalDashboardViewDescriptionMinHeight = 200;
const double kdCreateProposalDashboardViewDescriptionMaxHeight = 500;
const double kdCreateProposalDashboardViewFieldBorderRadius = 20;
const double kdCreateProposalDashboardViewFieldPadding = 10;
const double kdCreateProposalDashboardViewFieldValidationTextSize = 12;

// update proposal dashboard view
const double kdUpdateProposalDashboardViewPadding = 20;
const double kdUpdateProposalDashboardViewDescriptionMinHeight = 200;
const double kdUpdateProposalDashboardViewDescriptionMaxHeight = 500;
const double kdUpdateProposalDashboardViewFieldBorderRadius = 20;
const double kdUpdateProposalDashboardViewFieldPadding = 10;
const double kdUpdateProposalDashboardViewFieldValidationTextSize = 12;
const double kdUpdateProposalDashboardViewDialogIconSize = 100;
const double kdUpdateProposalDashboardViewTitleTextSize = 25;
const double kdUpdateProposalDashboardViewSubtitleTextSize = 20;
const double kdUpdateProposalDashboardViewIconSize = 35;

// submission proposal widget
const double kdSubmissionProposalWidgetPadding = 20;
const double kdSubmissionProposalWidgetShapeRadius = 20;
const double kdSubmissionProposalWidgetSendButtonFontSize = 16;
const double kdSubmissionProposalWidgetInfoIconSize = 30;
const double kdSubmissionProposalWidgetFieldBorderRadius = 20;
const double kdSubmissionProposalWidgetTitleFontSize = 20;
const double kdSubmissionProposalWidgetSubtitleFontSize = 14;

// submissions view
const int kiSubmissionsViewPageSize = 10;

// sidebar
const int kiSidebarHomeMenuIndex = 0;
const int kiSidebarAboutMenuIndex = 1;
const int kiSidebarLoginMenuIndex = 2;
const int kiSidebarRegisterMenuIndex = 3;
const int kiSidebarProfilesMenuIndex = 3;
const int kiSidebarProblemsMenuIndex = 4;
const int kiSidebarProblemProposalsMenuIndex = 5;
const int kiSidebarProposalDashboardMenuIndex = 6;

const double kdSidebarPadding = 10;
const double kdSidebarShapeRadius = 20;
const double kdSidebarItemPadding = 30;
const double kdSidebarSelectedItemPadding = 30;
const double kdSidebarItemShapeRadius = 10;
const double kdSidebarSelectedItemShapeRadius = 10;
const double kdSidebarSelectedItemBlurRadius = 30;
const double kdSidebarItemIconSize = 20;
const double kdSidebarSelectedItemIconSize = 20;
const double kdSidebarExtendedWidth = 200;
const double kdSidebarHeaderHeight = 100;
const double kdSidebarHeaderPadding = 16;
const double kdSidebarAvatarShapeRadius = 50;

const String ksSidebarHomeMenuText = 'Home';
const String ksSidebarAboutMenuText = 'About';
const String ksSidebarLoginMenuText = 'Login';
const String ksSidebarRegisterMenuText = 'Register';
const String ksSidebarLogoutMenuText = 'Logout';
const String ksSidebarProfilesMenuText = 'Profiles';
const String ksSidebarProblemsMenuText = 'Problems';
const String kdSidebarProblemProposalsMenuText = 'Proposals';
const String kdSidebarProposalDashboardMenuText = 'Dashboard';

// general
const double kdFabDistance = 100;
