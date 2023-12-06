/// The max width the content can ever take up on the screen
const double kdDesktopMaxContentWidth = 1150;

// The max height the homeview will take up
const double kdDesktopMaxContentHeight = 750;

// title text font size for desktop
const double kdDesktopTitleTextSize = 24;

// subtitle text font size for desktop
const double kdDesktopSubtitleTextSize = 14;

// busy keys
const String kbLoginKey = 'login';
const String kbRegisterKey = 'register';

// validation constants
const int kMinUsernameLength = 3;
const kEmailRegex = r'^[\w\-\.]+@([\w-]+\.)+[\w-]{2,4}$';
const int kMinPasswordLength = 6;
const int kMaxPasswordLength = 20;
const kPasswordRegex =
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^\da-zA-Z]).{6,20}$';

// placeholders
const String kRiveMoveEyesPadding = '--------------------------';
