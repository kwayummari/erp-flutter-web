import 'package:erp/src/screens/dashboard/dashboard.dart';
import 'package:erp/src/utils/routes/route-names.dart';
import 'package:erp/src/screens/authentication/login.dart';
import 'package:erp/src/screens/authentication/registration.dart';
import 'package:erp/src/screens/splash/splash.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: RouteNames.splash,
  routes: [
    GoRoute(
      path: RouteNames.login,
      builder: (context, state) => Login(),
    ),
    GoRoute(
      path: RouteNames.registration,
      builder: (context, state) => Registration(),
    ),
    GoRoute(
      path: RouteNames.splash,
      builder: (context, state) => Splash(),
    ),
    GoRoute(
      path: RouteNames.dashboard,
      builder: (context, state) => dashboard(),
    ),
  ],
);