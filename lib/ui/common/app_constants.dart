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
const String kbProfileKey = 'profile';

// validation constants
const int kMinUsernameLength = 3;
const kEmailRegex = r'^[\w\-\.]+@([\w-]+\.)+[\w-]{2,4}$';
const int kMinPasswordLength = 6;
const int kMaxPasswordLength = 20;
const kPasswordRegex =
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^\da-zA-Z]).{6,20}$';

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

// about view
const double kdAboutViewPadding = 20;
const double kdAboutViewTextSize = 15;
const double kdAboutViewTextLetterSpacing = 1;
const double kdAboutViewTextPadding = 15;

// profile view
const double kdProfileViewPadding = 20;
const double kdUserListAvatarShapeRadius = 70;

// sidebar
const int kiSidebarHomeMenuIndex = 0;
const int kiSidebarAboutMenuIndex = 1;
const int kiSidebarLoginMenuIndex = 2;
const int kiSidebarRegisterMenuIndex = 3;
const int kiSidebarProfileMenuIndex = 3;

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
const String ksSidebarProfileMenuText = 'Profile';
