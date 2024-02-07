// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i14;

import 'package:flutter/foundation.dart' as _i13;
import 'package:flutter/material.dart' as _i12;
import 'package:stacked/stacked.dart' as _i11;
import 'package:stacked_services/stacked_services.dart' as _i10;

import '../ui/views/about/about_view.dart' as _i5;
import '../ui/views/home/home_view.dart' as _i2;
import '../ui/views/login/login_view.dart' as _i3;
import '../ui/views/problems/problems_view.dart' as _i8;
import '../ui/views/profiles/profiles_view.dart' as _i6;
import '../ui/views/register/register_view.dart' as _i4;
import '../ui/views/single_profile/single_profile_view.dart' as _i7;
import '../ui/views/startup/startup_view.dart' as _i1;
import '../ui/views/unknown/unknown_view.dart' as _i9;

final stackedRouter =
    StackedRouterWeb(navigatorKey: _i10.StackedService.navigatorKey);

class StackedRouterWeb extends _i11.RootStackRouter {
  StackedRouterWeb({_i12.GlobalKey<_i12.NavigatorState>? navigatorKey})
      : super(navigatorKey);

  @override
  final Map<String, _i11.PageFactory> pagesMap = {
    StartupViewRoute.name: (routeData) {
      return _i11.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i1.StartupView(),
        opaque: true,
        barrierDismissible: false,
      );
    },
    HomeViewRoute.name: (routeData) {
      final args =
          routeData.argsAs<HomeViewArgs>(orElse: () => const HomeViewArgs());
      return _i11.CustomPage<dynamic>(
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
      return _i11.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i3.LoginView(),
      );
    },
    RegisterViewRoute.name: (routeData) {
      return _i11.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i4.RegisterView(),
      );
    },
    AboutViewRoute.name: (routeData) {
      return _i11.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i5.AboutView(),
      );
    },
    ProfilesViewRoute.name: (routeData) {
      return _i11.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i6.ProfilesView(),
      );
    },
    SingleProfileViewRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<SingleProfileViewArgs>(
          orElse: () =>
              SingleProfileViewArgs(userId: pathParams.getString('userId')));
      return _i11.MaterialPageX<dynamic>(
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
      return _i11.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i8.ProblemsView(
          debounce: args.debounce,
          key: args.key,
        ),
      );
    },
    UnknownViewRoute.name: (routeData) {
      return _i11.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i9.UnknownView(),
        opaque: true,
        barrierDismissible: false,
      );
    },
  };

  @override
  List<_i11.RouteConfig> get routes => [
        _i11.RouteConfig(
          StartupViewRoute.name,
          path: '/',
        ),
        _i11.RouteConfig(
          HomeViewRoute.name,
          path: '/home',
        ),
        _i11.RouteConfig(
          LoginViewRoute.name,
          path: '/login',
        ),
        _i11.RouteConfig(
          RegisterViewRoute.name,
          path: '/register',
        ),
        _i11.RouteConfig(
          AboutViewRoute.name,
          path: '/about',
        ),
        _i11.RouteConfig(
          ProfilesViewRoute.name,
          path: '/profiles',
        ),
        _i11.RouteConfig(
          SingleProfileViewRoute.name,
          path: '/profiles/:userId',
        ),
        _i11.RouteConfig(
          ProblemsViewRoute.name,
          path: '/problems',
        ),
        _i11.RouteConfig(
          UnknownViewRoute.name,
          path: '/404',
        ),
        _i11.RouteConfig(
          '*#redirect',
          path: '*',
          redirectTo: '/404',
          fullMatch: true,
        ),
      ];
}

/// generated route for
/// [_i1.StartupView]
class StartupViewRoute extends _i11.PageRouteInfo<void> {
  const StartupViewRoute()
      : super(
          StartupViewRoute.name,
          path: '/',
        );

  static const String name = 'StartupView';
}

/// generated route for
/// [_i2.HomeView]
class HomeViewRoute extends _i11.PageRouteInfo<HomeViewArgs> {
  HomeViewRoute({
    String? warningMessage,
    _i13.Key? key,
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

  final _i13.Key? key;

  @override
  String toString() {
    return 'HomeViewArgs{warningMessage: $warningMessage, key: $key}';
  }
}

/// generated route for
/// [_i3.LoginView]
class LoginViewRoute extends _i11.PageRouteInfo<void> {
  const LoginViewRoute()
      : super(
          LoginViewRoute.name,
          path: '/login',
        );

  static const String name = 'LoginView';
}

/// generated route for
/// [_i4.RegisterView]
class RegisterViewRoute extends _i11.PageRouteInfo<void> {
  const RegisterViewRoute()
      : super(
          RegisterViewRoute.name,
          path: '/register',
        );

  static const String name = 'RegisterView';
}

/// generated route for
/// [_i5.AboutView]
class AboutViewRoute extends _i11.PageRouteInfo<void> {
  const AboutViewRoute()
      : super(
          AboutViewRoute.name,
          path: '/about',
        );

  static const String name = 'AboutView';
}

/// generated route for
/// [_i6.ProfilesView]
class ProfilesViewRoute extends _i11.PageRouteInfo<void> {
  const ProfilesViewRoute()
      : super(
          ProfilesViewRoute.name,
          path: '/profiles',
        );

  static const String name = 'ProfilesView';
}

/// generated route for
/// [_i7.SingleProfileView]
class SingleProfileViewRoute extends _i11.PageRouteInfo<SingleProfileViewArgs> {
  SingleProfileViewRoute({
    required String userId,
    _i13.Key? key,
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

  final _i13.Key? key;

  @override
  String toString() {
    return 'SingleProfileViewArgs{userId: $userId, key: $key}';
  }
}

/// generated route for
/// [_i8.ProblemsView]
class ProblemsViewRoute extends _i11.PageRouteInfo<ProblemsViewArgs> {
  ProblemsViewRoute({
    _i14.Timer? debounce,
    _i13.Key? key,
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

  final _i14.Timer? debounce;

  final _i13.Key? key;

  @override
  String toString() {
    return 'ProblemsViewArgs{debounce: $debounce, key: $key}';
  }
}

/// generated route for
/// [_i9.UnknownView]
class UnknownViewRoute extends _i11.PageRouteInfo<void> {
  const UnknownViewRoute()
      : super(
          UnknownViewRoute.name,
          path: '/404',
        );

  static const String name = 'UnknownView';
}

extension RouterStateExtension on _i10.RouterService {
  Future<dynamic> navigateToStartupView(
      {void Function(_i11.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const StartupViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToHomeView({
    String? warningMessage,
    _i13.Key? key,
    void Function(_i11.NavigationFailure)? onFailure,
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
      {void Function(_i11.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const LoginViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToRegisterView(
      {void Function(_i11.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const RegisterViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToAboutView(
      {void Function(_i11.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const AboutViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToProfilesView(
      {void Function(_i11.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const ProfilesViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToSingleProfileView({
    required String userId,
    _i13.Key? key,
    void Function(_i11.NavigationFailure)? onFailure,
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
    _i14.Timer? debounce,
    _i13.Key? key,
    void Function(_i11.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      ProblemsViewRoute(
        debounce: debounce,
        key: key,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToUnknownView(
      {void Function(_i11.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const UnknownViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithStartupView(
      {void Function(_i11.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const StartupViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithHomeView({
    String? warningMessage,
    _i13.Key? key,
    void Function(_i11.NavigationFailure)? onFailure,
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
      {void Function(_i11.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const LoginViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithRegisterView(
      {void Function(_i11.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const RegisterViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithAboutView(
      {void Function(_i11.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const AboutViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithProfilesView(
      {void Function(_i11.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const ProfilesViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithSingleProfileView({
    required String userId,
    _i13.Key? key,
    void Function(_i11.NavigationFailure)? onFailure,
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
    _i14.Timer? debounce,
    _i13.Key? key,
    void Function(_i11.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      ProblemsViewRoute(
        debounce: debounce,
        key: key,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithUnknownView(
      {void Function(_i11.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const UnknownViewRoute(),
      onFailure: onFailure,
    );
  }
}
