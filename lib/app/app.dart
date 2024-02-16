import 'package:midgard/services/auth_service.dart';
import 'package:midgard/services/hive_service.dart';
import 'package:midgard/services/problem_service.dart';
import 'package:midgard/services/user_service.dart';
import 'package:midgard/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:midgard/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:midgard/ui/views/about/about_view.dart';
import 'package:midgard/ui/views/create_proposal_dashboard/create_proposal_dashboard_view.dart';
import 'package:midgard/ui/views/home/home_view.dart';
import 'package:midgard/ui/views/login/login_view.dart';
import 'package:midgard/ui/views/problem_proposals/problem_proposals_view.dart';
import 'package:midgard/ui/views/problems/problems_view.dart';
import 'package:midgard/ui/views/profiles/profiles_view.dart';
import 'package:midgard/ui/views/register/register_view.dart';
import 'package:midgard/ui/views/single_problem/single_problem_view.dart';
import 'package:midgard/ui/views/single_problem_proposal/single_problem_proposal_view.dart';
import 'package:midgard/ui/views/single_profile/single_profile_view.dart';
import 'package:midgard/ui/views/startup/startup_view.dart';
import 'package:midgard/ui/views/unknown/unknown_view.dart';
import 'package:midgard/ui/views/update_proposal_dashboard/update_proposal_dashboard_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: StartupView, initial: true),
    MaterialRoute(page: HomeView, path: '/home'),
    MaterialRoute(page: LoginView, path: '/login'),
    MaterialRoute(page: RegisterView, path: '/register'),
    MaterialRoute(page: AboutView, path: '/about'),
    MaterialRoute(page: ProfilesView, path: '/profiles'),
    MaterialRoute(page: SingleProfileView, path: '/profiles/:userId'),
    MaterialRoute(page: ProblemsView, path: '/problems'),
    MaterialRoute(page: SingleProblemView, path: '/problems/:problemId'),
    MaterialRoute(page: ProblemProposalsView, path: '/proposals'),
    MaterialRoute(
      page: SingleProblemProposalView,
      path: '/proposals/:problemId',
    ),
    MaterialRoute(
      page: CreateProposalDashboardView,
      path: '/dashboard/create',
    ),
    MaterialRoute(
      page: UpdateProposalDashboardView,
      path: '/dashboard/update/:problemId',
    ),
// @stacked-route

    MaterialRoute(page: UnknownView, path: '/404'),

    /// When none of the above routes match, redirect to UnknownView
    RedirectRoute(path: '*', redirectTo: '/404'),
  ],
  dependencies: [
    LazySingleton<BottomSheetService>(classType: BottomSheetService),
    LazySingleton<DialogService>(classType: DialogService),
    LazySingleton<RouterService>(classType: RouterService),
    LazySingleton<AuthService>(classType: AuthService),
    LazySingleton<HiveService>(classType: HiveService),
    LazySingleton<UserService>(classType: UserService),
    LazySingleton<ProblemService>(classType: ProblemService),
// @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    // @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    // @stacked-dialog
  ],
  logger: StackedLogger(),
)
class App {}
