part of 'app_pages.dart';

/// used to switch pages
class Routes {
  static const dashboard = _Paths.dashboard;
  static const calendar = _Paths.calendar;
  static const login = _Paths.login;
  static const reports = _Paths.reports;

}

/// contains a list of route names.
// made separately to make it easier to manage route naming
class _Paths {
  static const dashboard = '/dashboard';

  static const calendar= '/calendar';

  static const login= '/login';

  static const reports= '/reports';

// Example :
  // static const index = '/';
  // static const splash = '/splash';
  // static const product = '/product';
}
