// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i21;

import 'package:flutter/foundation.dart' as _i20;
import 'package:flutter/material.dart' as _i19;
import 'package:stacked/stacked.dart' as _i18;
import 'package:stacked_services/stacked_services.dart' as _i17;

import '../ui/views/about/about_view.dart' as _i5;
import '../ui/views/create_proposal_dashboard/create_proposal_dashboard_view.dart'
    as _i12;
import '../ui/views/home/home_view.dart' as _i2;
import '../ui/views/login/login_view.dart' as _i3;
import '../ui/views/problem_proposals/problem_proposals_view.dart' as _i10;
import '../ui/views/problems/problems_view.dart' as _i8;
import '../ui/views/profiles/profiles_view.dart' as _i6;
import '../ui/views/register/register_view.dart' as _i4;
import '../ui/views/single_problem/single_problem_view.dart' as _i9;
import '../ui/views/single_problem_proposal/single_problem_proposal_view.dart'
    as _i11;
import '../ui/views/single_profile/single_profile_view.dart' as _i7;
import '../ui/views/single_submission_details/single_submission_details_view.dart'
    as _i15;
import '../ui/views/startup/startup_view.dart' as _i1;
import '../ui/views/submissions/submissions_view.dart' as _i14;
import '../ui/views/unknown/unknown_view.dart' as _i16;
import '../ui/views/update_proposal_dashboard/update_proposal_dashboard_view.dart'
    as _i13;

final stackedRouter =
    StackedRouterWeb(navigatorKey: _i17.StackedService.navigatorKey);

class StackedRouterWeb extends _i18.RootStackRouter {
  StackedRouterWeb({_i19.GlobalKey<_i19.NavigatorState>? navigatorKey})
      : super(navigatorKey);

  @override
  final Map<String, _i18.PageFactory> pagesMap = {
    StartupViewRoute.name: (routeData) {
      return _i18.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i1.StartupView(),
      );
    },
    HomeViewRoute.name: (routeData) {
      final args =
          routeData.argsAs<HomeViewArgs>(orElse: () => const HomeViewArgs());
      return _i18.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i2.HomeView(
          warningMessage: args.warningMessage,
          key: args.key,
        ),
      );
    },
    LoginViewRoute.name: (routeData) {
      return _i18.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i3.LoginView(),
      );
    },
    RegisterViewRoute.name: (routeData) {
      return _i18.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i4.RegisterView(),
      );
    },
    AboutViewRoute.name: (routeData) {
      return _i18.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i5.AboutView(),
      );
    },
    ProfilesViewRoute.name: (routeData) {
      return _i18.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i6.ProfilesView(),
      );
    },
    SingleProfileViewRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<SingleProfileViewArgs>(
          orElse: () =>
              SingleProfileViewArgs(userId: pathParams.getString('userId')));
      return _i18.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i7.SingleProfileView(
          userId: args.userId,
          key: args.key,
        ),
      );
    },
    ProblemsViewRoute.name: (routeData) {
      final args = routeData.argsAs<ProblemsViewArgs>(
          orElse: () => const ProblemsViewArgs());
      return _i18.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i8.ProblemsView(
          debounce: args.debounce,
          key: args.key,
        ),
      );
    },
    SingleProblemViewRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<SingleProblemViewArgs>(
          orElse: () => SingleProblemViewArgs(
              problemId: pathParams.getString('problemId')));
      return _i18.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i9.SingleProblemView(
          problemId: args.problemId,
          key: args.key,
        ),
      );
    },
    ProblemProposalsViewRoute.name: (routeData) {
      return _i18.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i10.ProblemProposalsView(),
      );
    },
    SingleProblemProposalViewRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<SingleProblemProposalViewArgs>(
          orElse: () => SingleProblemProposalViewArgs(
              problemId: pathParams.getString('problemId')));
      return _i18.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i11.SingleProblemProposalView(
          problemId: args.problemId,
          key: args.key,
        ),
      );
    },
    CreateProposalDashboardViewRoute.name: (routeData) {
      return _i18.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i12.CreateProposalDashboardView(),
      );
    },
    UpdateProposalDashboardViewRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<UpdateProposalDashboardViewArgs>(
          orElse: () => UpdateProposalDashboardViewArgs(
              problemId: pathParams.getString('problemId')));
      return _i18.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i13.UpdateProposalDashboardView(
          problemId: args.problemId,
          key: args.key,
        ),
      );
    },
    SubmissionsViewRoute.name: (routeData) {
      return _i18.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i14.SubmissionsView(),
      );
    },
    SingleSubmissionDetailsViewRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final queryParams = routeData.queryParams;
      final args = routeData.argsAs<SingleSubmissionDetailsViewArgs>(
          orElse: () => SingleSubmissionDetailsViewArgs(
                submissionId: pathParams.getString('submissionId'),
                problemId: queryParams.optString('problemId'),
                isPublished: queryParams.optBool('isPublished'),
              ));
      return _i18.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i15.SingleSubmissionDetailsView(
          submissionId: args.submissionId,
          problemId: args.problemId,
          isPublished: args.isPublished,
          key: args.key,
        ),
      );
    },
    UnknownViewRoute.name: (routeData) {
      return _i18.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i16.UnknownView(),
      );
    },
  };

  @override
  List<_i18.RouteConfig> get routes => [
        _i18.RouteConfig(
          StartupViewRoute.name,
          path: '/',
        ),
        _i18.RouteConfig(
          HomeViewRoute.name,
          path: '/home',
        ),
        _i18.RouteConfig(
          LoginViewRoute.name,
          path: '/login',
        ),
        _i18.RouteConfig(
          RegisterViewRoute.name,
          path: '/register',
        ),
        _i18.RouteConfig(
          AboutViewRoute.name,
          path: '/about',
        ),
        _i18.RouteConfig(
          ProfilesViewRoute.name,
          path: '/profiles',
        ),
        _i18.RouteConfig(
          SingleProfileViewRoute.name,
          path: '/profiles/:userId',
        ),
        _i18.RouteConfig(
          ProblemsViewRoute.name,
          path: '/problems',
        ),
        _i18.RouteConfig(
          SingleProblemViewRoute.name,
          path: '/problems/:problemId',
        ),
        _i18.RouteConfig(
          ProblemProposalsViewRoute.name,
          path: '/proposals',
        ),
        _i18.RouteConfig(
          SingleProblemProposalViewRoute.name,
          path: '/proposals/:problemId',
        ),
        _i18.RouteConfig(
          CreateProposalDashboardViewRoute.name,
          path: '/dashboard/create',
        ),
        _i18.RouteConfig(
          UpdateProposalDashboardViewRoute.name,
          path: '/dashboard/update/:problemId',
        ),
        _i18.RouteConfig(
          SubmissionsViewRoute.name,
          path: '/submissions',
        ),
        _i18.RouteConfig(
          SingleSubmissionDetailsViewRoute.name,
          path: '/submissions/:submissionId',
        ),
        _i18.RouteConfig(
          UnknownViewRoute.name,
          path: '/404',
        ),
        _i18.RouteConfig(
          '*#redirect',
          path: '*',
          redirectTo: '/404',
          fullMatch: true,
        ),
      ];
}

/// generated route for
/// [_i1.StartupView]
class StartupViewRoute extends _i18.PageRouteInfo<void> {
  const StartupViewRoute()
      : super(
          StartupViewRoute.name,
          path: '/',
        );

  static const String name = 'StartupView';
}

/// generated route for
/// [_i2.HomeView]
class HomeViewRoute extends _i18.PageRouteInfo<HomeViewArgs> {
  HomeViewRoute({
    String? warningMessage,
    _i20.Key? key,
  }) : super(
          HomeViewRoute.name,
          path: '/home',
          args: HomeViewArgs(
            warningMessage: warningMessage,
            key: key,
          ),
        );

  static const String name = 'HomeView';
}

class HomeViewArgs {
  const HomeViewArgs({
    this.warningMessage,
    this.key,
  });

  final String? warningMessage;

  final _i20.Key? key;

  @override
  String toString() {
    return 'HomeViewArgs{warningMessage: $warningMessage, key: $key}';
  }
}

/// generated route for
/// [_i3.LoginView]
class LoginViewRoute extends _i18.PageRouteInfo<void> {
  const LoginViewRoute()
      : super(
          LoginViewRoute.name,
          path: '/login',
        );

  static const String name = 'LoginView';
}

/// generated route for
/// [_i4.RegisterView]
class RegisterViewRoute extends _i18.PageRouteInfo<void> {
  const RegisterViewRoute()
      : super(
          RegisterViewRoute.name,
          path: '/register',
        );

  static const String name = 'RegisterView';
}

/// generated route for
/// [_i5.AboutView]
class AboutViewRoute extends _i18.PageRouteInfo<void> {
  const AboutViewRoute()
      : super(
          AboutViewRoute.name,
          path: '/about',
        );

  static const String name = 'AboutView';
}

/// generated route for
/// [_i6.ProfilesView]
class ProfilesViewRoute extends _i18.PageRouteInfo<void> {
  const ProfilesViewRoute()
      : super(
          ProfilesViewRoute.name,
          path: '/profiles',
        );

  static const String name = 'ProfilesView';
}

/// generated route for
/// [_i7.SingleProfileView]
class SingleProfileViewRoute extends _i18.PageRouteInfo<SingleProfileViewArgs> {
  SingleProfileViewRoute({
    required String userId,
    _i20.Key? key,
  }) : super(
          SingleProfileViewRoute.name,
          path: '/profiles/:userId',
          args: SingleProfileViewArgs(
            userId: userId,
            key: key,
          ),
          rawPathParams: {'userId': userId},
        );

  static const String name = 'SingleProfileView';
}

class SingleProfileViewArgs {
  const SingleProfileViewArgs({
    required this.userId,
    this.key,
  });

  final String userId;

  final _i20.Key? key;

  @override
  String toString() {
    return 'SingleProfileViewArgs{userId: $userId, key: $key}';
  }
}

/// generated route for
/// [_i8.ProblemsView]
class ProblemsViewRoute extends _i18.PageRouteInfo<ProblemsViewArgs> {
  ProblemsViewRoute({
    _i21.Timer? debounce,
    _i20.Key? key,
  }) : super(
          ProblemsViewRoute.name,
          path: '/problems',
          args: ProblemsViewArgs(
            debounce: debounce,
            key: key,
          ),
        );

  static const String name = 'ProblemsView';
}

class ProblemsViewArgs {
  const ProblemsViewArgs({
    this.debounce,
    this.key,
  });

  final _i21.Timer? debounce;

  final _i20.Key? key;

  @override
  String toString() {
    return 'ProblemsViewArgs{debounce: $debounce, key: $key}';
  }
}

/// generated route for
/// [_i9.SingleProblemView]
class SingleProblemViewRoute extends _i18.PageRouteInfo<SingleProblemViewArgs> {
  SingleProblemViewRoute({
    required String problemId,
    _i20.Key? key,
  }) : super(
          SingleProblemViewRoute.name,
          path: '/problems/:problemId',
          args: SingleProblemViewArgs(
            problemId: problemId,
            key: key,
          ),
          rawPathParams: {'problemId': problemId},
        );

  static const String name = 'SingleProblemView';
}

class SingleProblemViewArgs {
  const SingleProblemViewArgs({
    required this.problemId,
    this.key,
  });

  final String problemId;

  final _i20.Key? key;

  @override
  String toString() {
    return 'SingleProblemViewArgs{problemId: $problemId, key: $key}';
  }
}

/// generated route for
/// [_i10.ProblemProposalsView]
class ProblemProposalsViewRoute extends _i18.PageRouteInfo<void> {
  const ProblemProposalsViewRoute()
      : super(
          ProblemProposalsViewRoute.name,
          path: '/proposals',
        );

  static const String name = 'ProblemProposalsView';
}

/// generated route for
/// [_i11.SingleProblemProposalView]
class SingleProblemProposalViewRoute
    extends _i18.PageRouteInfo<SingleProblemProposalViewArgs> {
  SingleProblemProposalViewRoute({
    required String problemId,
    _i20.Key? key,
  }) : super(
          SingleProblemProposalViewRoute.name,
          path: '/proposals/:problemId',
          args: SingleProblemProposalViewArgs(
            problemId: problemId,
            key: key,
          ),
          rawPathParams: {'problemId': problemId},
        );

  static const String name = 'SingleProblemProposalView';
}

class SingleProblemProposalViewArgs {
  const SingleProblemProposalViewArgs({
    required this.problemId,
    this.key,
  });

  final String problemId;

  final _i20.Key? key;

  @override
  String toString() {
    return 'SingleProblemProposalViewArgs{problemId: $problemId, key: $key}';
  }
}

/// generated route for
/// [_i12.CreateProposalDashboardView]
class CreateProposalDashboardViewRoute extends _i18.PageRouteInfo<void> {
  const CreateProposalDashboardViewRoute()
      : super(
          CreateProposalDashboardViewRoute.name,
          path: '/dashboard/create',
        );

  static const String name = 'CreateProposalDashboardView';
}

/// generated route for
/// [_i13.UpdateProposalDashboardView]
class UpdateProposalDashboardViewRoute
    extends _i18.PageRouteInfo<UpdateProposalDashboardViewArgs> {
  UpdateProposalDashboardViewRoute({
    required String problemId,
    _i20.Key? key,
  }) : super(
          UpdateProposalDashboardViewRoute.name,
          path: '/dashboard/update/:problemId',
          args: UpdateProposalDashboardViewArgs(
            problemId: problemId,
            key: key,
          ),
          rawPathParams: {'problemId': problemId},
        );

  static const String name = 'UpdateProposalDashboardView';
}

class UpdateProposalDashboardViewArgs {
  const UpdateProposalDashboardViewArgs({
    required this.problemId,
    this.key,
  });

  final String problemId;

  final _i20.Key? key;

  @override
  String toString() {
    return 'UpdateProposalDashboardViewArgs{problemId: $problemId, key: $key}';
  }
}

/// generated route for
/// [_i14.SubmissionsView]
class SubmissionsViewRoute extends _i18.PageRouteInfo<void> {
  const SubmissionsViewRoute()
      : super(
          SubmissionsViewRoute.name,
          path: '/submissions',
        );

  static const String name = 'SubmissionsView';
}

/// generated route for
/// [_i15.SingleSubmissionDetailsView]
class SingleSubmissionDetailsViewRoute
    extends _i18.PageRouteInfo<SingleSubmissionDetailsViewArgs> {
  SingleSubmissionDetailsViewRoute({
    required String submissionId,
    String? problemId,
    bool? isPublished,
    _i20.Key? key,
  }) : super(
          SingleSubmissionDetailsViewRoute.name,
          path: '/submissions/:submissionId',
          args: SingleSubmissionDetailsViewArgs(
            submissionId: submissionId,
            problemId: problemId,
            isPublished: isPublished,
            key: key,
          ),
          rawPathParams: {'submissionId': submissionId},
          rawQueryParams: {
            'problemId': problemId,
            'isPublished': isPublished,
          },
        );

  static const String name = 'SingleSubmissionDetailsView';
}

class SingleSubmissionDetailsViewArgs {
  const SingleSubmissionDetailsViewArgs({
    required this.submissionId,
    this.problemId,
    this.isPublished,
    this.key,
  });

  final String submissionId;

  final String? problemId;

  final bool? isPublished;

  final _i20.Key? key;

  @override
  String toString() {
    return 'SingleSubmissionDetailsViewArgs{submissionId: $submissionId, problemId: $problemId, isPublished: $isPublished, key: $key}';
  }
}

/// generated route for
/// [_i16.UnknownView]
class UnknownViewRoute extends _i18.PageRouteInfo<void> {
  const UnknownViewRoute()
      : super(
          UnknownViewRoute.name,
          path: '/404',
        );

  static const String name = 'UnknownView';
}

extension RouterStateExtension on _i17.RouterService {
  Future<dynamic> navigateToStartupView(
      {void Function(_i18.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const StartupViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToHomeView({
    String? warningMessage,
    _i20.Key? key,
    void Function(_i18.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      HomeViewRoute(
        warningMessage: warningMessage,
        key: key,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToLoginView(
      {void Function(_i18.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const LoginViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToRegisterView(
      {void Function(_i18.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const RegisterViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToAboutView(
      {void Function(_i18.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const AboutViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToProfilesView(
      {void Function(_i18.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const ProfilesViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToSingleProfileView({
    required String userId,
    _i20.Key? key,
    void Function(_i18.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      SingleProfileViewRoute(
        userId: userId,
        key: key,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToProblemsView({
    _i21.Timer? debounce,
    _i20.Key? key,
    void Function(_i18.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      ProblemsViewRoute(
        debounce: debounce,
        key: key,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToSingleProblemView({
    required String problemId,
    _i20.Key? key,
    void Function(_i18.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      SingleProblemViewRoute(
        problemId: problemId,
        key: key,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToProblemProposalsView(
      {void Function(_i18.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const ProblemProposalsViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToSingleProblemProposalView({
    required String problemId,
    _i20.Key? key,
    void Function(_i18.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      SingleProblemProposalViewRoute(
        problemId: problemId,
        key: key,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToCreateProposalDashboardView(
      {void Function(_i18.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const CreateProposalDashboardViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToUpdateProposalDashboardView({
    required String problemId,
    _i20.Key? key,
    void Function(_i18.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      UpdateProposalDashboardViewRoute(
        problemId: problemId,
        key: key,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToSubmissionsView(
      {void Function(_i18.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const SubmissionsViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToSingleSubmissionDetailsView({
    required String submissionId,
    String? problemId,
    bool? isPublished,
    _i20.Key? key,
    void Function(_i18.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      SingleSubmissionDetailsViewRoute(
        submissionId: submissionId,
        problemId: problemId,
        isPublished: isPublished,
        key: key,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToUnknownView(
      {void Function(_i18.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const UnknownViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithStartupView(
      {void Function(_i18.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const StartupViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithHomeView({
    String? warningMessage,
    _i20.Key? key,
    void Function(_i18.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      HomeViewRoute(
        warningMessage: warningMessage,
        key: key,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithLoginView(
      {void Function(_i18.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const LoginViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithRegisterView(
      {void Function(_i18.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const RegisterViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithAboutView(
      {void Function(_i18.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const AboutViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithProfilesView(
      {void Function(_i18.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const ProfilesViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithSingleProfileView({
    required String userId,
    _i20.Key? key,
    void Function(_i18.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      SingleProfileViewRoute(
        userId: userId,
        key: key,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithProblemsView({
    _i21.Timer? debounce,
    _i20.Key? key,
    void Function(_i18.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      ProblemsViewRoute(
        debounce: debounce,
        key: key,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithSingleProblemView({
    required String problemId,
    _i20.Key? key,
    void Function(_i18.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      SingleProblemViewRoute(
        problemId: problemId,
        key: key,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithProblemProposalsView(
      {void Function(_i18.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const ProblemProposalsViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithSingleProblemProposalView({
    required String problemId,
    _i20.Key? key,
    void Function(_i18.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      SingleProblemProposalViewRoute(
        problemId: problemId,
        key: key,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithCreateProposalDashboardView(
      {void Function(_i18.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const CreateProposalDashboardViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithUpdateProposalDashboardView({
    required String problemId,
    _i20.Key? key,
    void Function(_i18.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      UpdateProposalDashboardViewRoute(
        problemId: problemId,
        key: key,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithSubmissionsView(
      {void Function(_i18.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const SubmissionsViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithSingleSubmissionDetailsView({
    required String submissionId,
    String? problemId,
    bool? isPublished,
    _i20.Key? key,
    void Function(_i18.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      SingleSubmissionDetailsViewRoute(
        submissionId: submissionId,
        problemId: problemId,
        isPublished: isPublished,
        key: key,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithUnknownView(
      {void Function(_i18.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const UnknownViewRoute(),
      onFailure: onFailure,
    );
  }
}
