// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/material.dart' as _i11;
import 'package:stacked/stacked.dart' as _i10;
import 'package:stacked_services/stacked_services.dart' as _i9;

import '../ui/views/about/about_view.dart' as _i5;
import '../ui/views/home/home_view.dart' as _i2;
import '../ui/views/login/login_view.dart' as _i3;
import '../ui/views/profiles/profiles_view.dart' as _i6;
import '../ui/views/register/register_view.dart' as _i4;
import '../ui/views/single_profile/single_profile_view.dart' as _i7;
import '../ui/views/startup/startup_view.dart' as _i1;
import '../ui/views/unknown/unknown_view.dart' as _i8;

final stackedRouter =
    StackedRouterWeb(navigatorKey: _i9.StackedService.navigatorKey);

class StackedRouterWeb extends _i10.RootStackRouter {
  StackedRouterWeb({_i11.GlobalKey<_i11.NavigatorState>? navigatorKey})
      : super(navigatorKey);

  @override
  final Map<String, _i10.PageFactory> pagesMap = {
    StartupViewRoute.name: (routeData) {
      return _i10.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i1.StartupView(),
        opaque: true,
        barrierDismissible: false,
      );
    },
    HomeViewRoute.name: (routeData) {
      return _i10.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i2.HomeView(),
        opaque: true,
        barrierDismissible: false,
      );
    },
    LoginViewRoute.name: (routeData) {
      return _i10.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i3.LoginView(),
      );
    },
    RegisterViewRoute.name: (routeData) {
      return _i10.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i4.RegisterView(),
      );
    },
    AboutViewRoute.name: (routeData) {
      return _i10.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i5.AboutView(),
      );
    },
    ProfilesViewRoute.name: (routeData) {
      return _i10.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i6.ProfilesView(),
      );
    },
    SingleProfileViewRoute.name: (routeData) {
      return _i10.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i7.SingleProfileView(),
      );
    },
    UnknownViewRoute.name: (routeData) {
      return _i10.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i8.UnknownView(),
        opaque: true,
        barrierDismissible: false,
      );
    },
  };

  @override
  List<_i10.RouteConfig> get routes => [
        _i10.RouteConfig(
          StartupViewRoute.name,
          path: '/',
        ),
        _i10.RouteConfig(
          HomeViewRoute.name,
          path: '/home',
        ),
        _i10.RouteConfig(
          LoginViewRoute.name,
          path: '/login',
        ),
        _i10.RouteConfig(
          RegisterViewRoute.name,
          path: '/register',
        ),
        _i10.RouteConfig(
          AboutViewRoute.name,
          path: '/about',
        ),
        _i10.RouteConfig(
          ProfilesViewRoute.name,
          path: '/profiles',
        ),
        _i10.RouteConfig(
          SingleProfileViewRoute.name,
          path: '/single-profile-view',
        ),
        _i10.RouteConfig(
          UnknownViewRoute.name,
          path: '/404',
        ),
        _i10.RouteConfig(
          '*#redirect',
          path: '*',
          redirectTo: '/404',
          fullMatch: true,
        ),
      ];
}

/// generated route for
/// [_i1.StartupView]
class StartupViewRoute extends _i10.PageRouteInfo<void> {
  const StartupViewRoute()
      : super(
          StartupViewRoute.name,
          path: '/',
        );

  static const String name = 'StartupView';
}

/// generated route for
/// [_i2.HomeView]
class HomeViewRoute extends _i10.PageRouteInfo<void> {
  const HomeViewRoute()
      : super(
          HomeViewRoute.name,
          path: '/home',
        );

  static const String name = 'HomeView';
}

/// generated route for
/// [_i3.LoginView]
class LoginViewRoute extends _i10.PageRouteInfo<void> {
  const LoginViewRoute()
      : super(
          LoginViewRoute.name,
          path: '/login',
        );

  static const String name = 'LoginView';
}

/// generated route for
/// [_i4.RegisterView]
class RegisterViewRoute extends _i10.PageRouteInfo<void> {
  const RegisterViewRoute()
      : super(
          RegisterViewRoute.name,
          path: '/register',
        );

  static const String name = 'RegisterView';
}

/// generated route for
/// [_i5.AboutView]
class AboutViewRoute extends _i10.PageRouteInfo<void> {
  const AboutViewRoute()
      : super(
          AboutViewRoute.name,
          path: '/about',
        );

  static const String name = 'AboutView';
}

/// generated route for
/// [_i6.ProfilesView]
class ProfilesViewRoute extends _i10.PageRouteInfo<void> {
  const ProfilesViewRoute()
      : super(
          ProfilesViewRoute.name,
          path: '/profiles',
        );

  static const String name = 'ProfilesView';
}

/// generated route for
/// [_i7.SingleProfileView]
class SingleProfileViewRoute extends _i10.PageRouteInfo<void> {
  const SingleProfileViewRoute()
      : super(
          SingleProfileViewRoute.name,
          path: '/single-profile-view',
        );

  static const String name = 'SingleProfileView';
}

/// generated route for
/// [_i8.UnknownView]
class UnknownViewRoute extends _i10.PageRouteInfo<void> {
  const UnknownViewRoute()
      : super(
          UnknownViewRoute.name,
          path: '/404',
        );

  static const String name = 'UnknownView';
}

extension RouterStateExtension on _i9.RouterService {
  Future<dynamic> navigateToStartupView(
      {void Function(_i10.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const StartupViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToHomeView(
      {void Function(_i10.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const HomeViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToLoginView(
      {void Function(_i10.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const LoginViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToRegisterView(
      {void Function(_i10.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const RegisterViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToAboutView(
      {void Function(_i10.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const AboutViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToProfilesView(
      {void Function(_i10.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const ProfilesViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToSingleProfileView(
      {void Function(_i10.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const SingleProfileViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToUnknownView(
      {void Function(_i10.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const UnknownViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithStartupView(
      {void Function(_i10.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const StartupViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithHomeView(
      {void Function(_i10.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const HomeViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithLoginView(
      {void Function(_i10.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const LoginViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithRegisterView(
      {void Function(_i10.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const RegisterViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithAboutView(
      {void Function(_i10.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const AboutViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithProfilesView(
      {void Function(_i10.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const ProfilesViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithSingleProfileView(
      {void Function(_i10.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const SingleProfileViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithUnknownView(
      {void Function(_i10.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const UnknownViewRoute(),
      onFailure: onFailure,
    );
  }
}
