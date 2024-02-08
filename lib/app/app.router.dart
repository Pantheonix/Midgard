// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i15;

import 'package:flutter/foundation.dart' as _i14;
import 'package:flutter/material.dart' as _i13;
import 'package:stacked/stacked.dart' as _i12;
import 'package:stacked_services/stacked_services.dart' as _i11;

import '../ui/views/about/about_view.dart' as _i5;
import '../ui/views/home/home_view.dart' as _i2;
import '../ui/views/login/login_view.dart' as _i3;
import '../ui/views/problems/problems_view.dart' as _i8;
import '../ui/views/profiles/profiles_view.dart' as _i6;
import '../ui/views/register/register_view.dart' as _i4;
import '../ui/views/single_problem/single_problem_view.dart' as _i9;
import '../ui/views/single_profile/single_profile_view.dart' as _i7;
import '../ui/views/startup/startup_view.dart' as _i1;
import '../ui/views/unknown/unknown_view.dart' as _i10;

final stackedRouter =
    StackedRouterWeb(navigatorKey: _i11.StackedService.navigatorKey);

class StackedRouterWeb extends _i12.RootStackRouter {
  StackedRouterWeb({_i13.GlobalKey<_i13.NavigatorState>? navigatorKey})
      : super(navigatorKey);

  @override
  final Map<String, _i12.PageFactory> pagesMap = {
    StartupViewRoute.name: (routeData) {
      return _i12.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i1.StartupView(),
        opaque: true,
        barrierDismissible: false,
      );
    },
    HomeViewRoute.name: (routeData) {
      final args =
          routeData.argsAs<HomeViewArgs>(orElse: () => const HomeViewArgs());
      return _i12.CustomPage<dynamic>(
        routeData: routeData,
        child: _i2.HomeView(
          warningMessage: args.warningMessage,
          key: args.key,
        ),
        opaque: true,
        barrierDismissible: false,
      );
    },
    LoginViewRoute.name: (routeData) {
      return _i12.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i3.LoginView(),
      );
    },
    RegisterViewRoute.name: (routeData) {
      return _i12.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i4.RegisterView(),
      );
    },
    AboutViewRoute.name: (routeData) {
      return _i12.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i5.AboutView(),
      );
    },
    ProfilesViewRoute.name: (routeData) {
      return _i12.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i6.ProfilesView(),
      );
    },
    SingleProfileViewRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<SingleProfileViewArgs>(
          orElse: () =>
              SingleProfileViewArgs(userId: pathParams.getString('userId')));
      return _i12.MaterialPageX<dynamic>(
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
      return _i12.MaterialPageX<dynamic>(
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
      return _i12.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i9.SingleProblemView(
          problemId: args.problemId,
          key: args.key,
        ),
      );
    },
    UnknownViewRoute.name: (routeData) {
      return _i12.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i10.UnknownView(),
        opaque: true,
        barrierDismissible: false,
      );
    },
  };

  @override
  List<_i12.RouteConfig> get routes => [
        _i12.RouteConfig(
          StartupViewRoute.name,
          path: '/',
        ),
        _i12.RouteConfig(
          HomeViewRoute.name,
          path: '/home',
        ),
        _i12.RouteConfig(
          LoginViewRoute.name,
          path: '/login',
        ),
        _i12.RouteConfig(
          RegisterViewRoute.name,
          path: '/register',
        ),
        _i12.RouteConfig(
          AboutViewRoute.name,
          path: '/about',
        ),
        _i12.RouteConfig(
          ProfilesViewRoute.name,
          path: '/profiles',
        ),
        _i12.RouteConfig(
          SingleProfileViewRoute.name,
          path: '/profiles/:userId',
        ),
        _i12.RouteConfig(
          ProblemsViewRoute.name,
          path: '/problems',
        ),
        _i12.RouteConfig(
          SingleProblemViewRoute.name,
          path: '/problems/:problemId',
        ),
        _i12.RouteConfig(
          UnknownViewRoute.name,
          path: '/404',
        ),
        _i12.RouteConfig(
          '*#redirect',
          path: '*',
          redirectTo: '/404',
          fullMatch: true,
        ),
      ];
}

/// generated route for
/// [_i1.StartupView]
class StartupViewRoute extends _i12.PageRouteInfo<void> {
  const StartupViewRoute()
      : super(
          StartupViewRoute.name,
          path: '/',
        );

  static const String name = 'StartupView';
}

/// generated route for
/// [_i2.HomeView]
class HomeViewRoute extends _i12.PageRouteInfo<HomeViewArgs> {
  HomeViewRoute({
    String? warningMessage,
    _i14.Key? key,
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

  final _i14.Key? key;

  @override
  String toString() {
    return 'HomeViewArgs{warningMessage: $warningMessage, key: $key}';
  }
}

/// generated route for
/// [_i3.LoginView]
class LoginViewRoute extends _i12.PageRouteInfo<void> {
  const LoginViewRoute()
      : super(
          LoginViewRoute.name,
          path: '/login',
        );

  static const String name = 'LoginView';
}

/// generated route for
/// [_i4.RegisterView]
class RegisterViewRoute extends _i12.PageRouteInfo<void> {
  const RegisterViewRoute()
      : super(
          RegisterViewRoute.name,
          path: '/register',
        );

  static const String name = 'RegisterView';
}

/// generated route for
/// [_i5.AboutView]
class AboutViewRoute extends _i12.PageRouteInfo<void> {
  const AboutViewRoute()
      : super(
          AboutViewRoute.name,
          path: '/about',
        );

  static const String name = 'AboutView';
}

/// generated route for
/// [_i6.ProfilesView]
class ProfilesViewRoute extends _i12.PageRouteInfo<void> {
  const ProfilesViewRoute()
      : super(
          ProfilesViewRoute.name,
          path: '/profiles',
        );

  static const String name = 'ProfilesView';
}

/// generated route for
/// [_i7.SingleProfileView]
class SingleProfileViewRoute extends _i12.PageRouteInfo<SingleProfileViewArgs> {
  SingleProfileViewRoute({
    required String userId,
    _i14.Key? key,
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

  final _i14.Key? key;

  @override
  String toString() {
    return 'SingleProfileViewArgs{userId: $userId, key: $key}';
  }
}

/// generated route for
/// [_i8.ProblemsView]
class ProblemsViewRoute extends _i12.PageRouteInfo<ProblemsViewArgs> {
  ProblemsViewRoute({
    _i15.Timer? debounce,
    _i14.Key? key,
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

  final _i15.Timer? debounce;

  final _i14.Key? key;

  @override
  String toString() {
    return 'ProblemsViewArgs{debounce: $debounce, key: $key}';
  }
}

/// generated route for
/// [_i9.SingleProblemView]
class SingleProblemViewRoute extends _i12.PageRouteInfo<SingleProblemViewArgs> {
  SingleProblemViewRoute({
    required String problemId,
    _i14.Key? key,
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

  final _i14.Key? key;

  @override
  String toString() {
    return 'SingleProblemViewArgs{problemId: $problemId, key: $key}';
  }
}

/// generated route for
/// [_i10.UnknownView]
class UnknownViewRoute extends _i12.PageRouteInfo<void> {
  const UnknownViewRoute()
      : super(
          UnknownViewRoute.name,
          path: '/404',
        );

  static const String name = 'UnknownView';
}

extension RouterStateExtension on _i11.RouterService {
  Future<dynamic> navigateToStartupView(
      {void Function(_i12.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const StartupViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToHomeView({
    String? warningMessage,
    _i14.Key? key,
    void Function(_i12.NavigationFailure)? onFailure,
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
      {void Function(_i12.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const LoginViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToRegisterView(
      {void Function(_i12.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const RegisterViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToAboutView(
      {void Function(_i12.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const AboutViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToProfilesView(
      {void Function(_i12.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const ProfilesViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToSingleProfileView({
    required String userId,
    _i14.Key? key,
    void Function(_i12.NavigationFailure)? onFailure,
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
    _i15.Timer? debounce,
    _i14.Key? key,
    void Function(_i12.NavigationFailure)? onFailure,
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
    _i14.Key? key,
    void Function(_i12.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      SingleProblemViewRoute(
        problemId: problemId,
        key: key,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToUnknownView(
      {void Function(_i12.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const UnknownViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithStartupView(
      {void Function(_i12.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const StartupViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithHomeView({
    String? warningMessage,
    _i14.Key? key,
    void Function(_i12.NavigationFailure)? onFailure,
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
      {void Function(_i12.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const LoginViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithRegisterView(
      {void Function(_i12.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const RegisterViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithAboutView(
      {void Function(_i12.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const AboutViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithProfilesView(
      {void Function(_i12.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const ProfilesViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithSingleProfileView({
    required String userId,
    _i14.Key? key,
    void Function(_i12.NavigationFailure)? onFailure,
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
    _i15.Timer? debounce,
    _i14.Key? key,
    void Function(_i12.NavigationFailure)? onFailure,
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
    _i14.Key? key,
    void Function(_i12.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      SingleProblemViewRoute(
        problemId: problemId,
        key: key,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithUnknownView(
      {void Function(_i12.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const UnknownViewRoute(),
      onFailure: onFailure,
    );
  }
}
