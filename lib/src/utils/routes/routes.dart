import 'package:erp/src/screens/dashboard/dashboard.dart';
import 'package:erp/src/screens/inventory/inventoryManagement.dart';
import 'package:erp/src/screens/roles/rolesManagement.dart';
import 'package:erp/src/screens/supplier/supplierManagement.dart';
import 'package:erp/src/screens/userManagement/userManagement.dart';
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
    GoRoute(
      path: RouteNames.userManagement,
      builder: (context, state) => userManagement(),
    ),
    GoRoute(
      path: RouteNames.inventory,
      builder: (context, state) => inventoryManagement(),
    ),
    GoRoute(
      path: RouteNames.supplier,
      builder: (context, state) => supplierManagement(),
    ),
    GoRoute(
      path: RouteNames.roles,
      builder: (context, state) => rolesManagement(),
    ),
  ],
);