import 'package:erp/src/screens/allsales/allSaleManagement.dart';
import 'package:erp/src/screens/branch/branchManagement.dart';
import 'package:erp/src/screens/customers/customers.dart';
import 'package:erp/src/screens/dashboard/dashboard.dart';
import 'package:erp/src/screens/grn/completedGrnLists.dart';
import 'package:erp/src/screens/grn/grn.dart';
import 'package:erp/src/screens/inventory/inventoryManagement.dart';
import 'package:erp/src/screens/purchaseOrder/purchaseOrder.dart';
import 'package:erp/src/screens/report/reportRange.dart';
import 'package:erp/src/screens/report/todayReport.dart';
import 'package:erp/src/screens/roles/permissions.dart';
import 'package:erp/src/screens/roles/rolesManagement.dart';
import 'package:erp/src/screens/sellProducts/print_page.dart';
import 'package:erp/src/screens/sellProducts/saleManagement.dart';
import 'package:erp/src/screens/supplier/supplierManagement.dart';
import 'package:erp/src/screens/userManagement/userManagement.dart';
import 'package:erp/src/utils/errors/notFound.dart';
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
    GoRoute(
      path: RouteNames.branch,
      builder: (context, state) => branchManagement(),
    ),
    GoRoute(
      path: RouteNames.purchaseOrder,
      builder: (context, state) => PurchaseOrderManagement(),
    ),
    GoRoute(
      path: RouteNames.grn,
      builder: (context, state) => GrnManagement(),
    ),
    GoRoute(
      path: RouteNames.completedGrn,
      builder: (context, state) => CompletedGrnListsManagement(),
    ),
    GoRoute(
      path: RouteNames.saleManagement,
      builder: (context, state) => SaleManagement(),
    ),
    GoRoute(
      path: RouteNames.allSaleManagement,
      builder: (context, state) => AllSalesManagement(),
    ),
    GoRoute(
      path: RouteNames.todayReport,
      builder: (context, state) => TodayReportManagement(),
    ),
    GoRoute(
      path: RouteNames.reportRange,
      builder: (context, state) => ReportRangeManagement(),
    ),
    GoRoute(
      path: RouteNames.permissions,
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        return PermissionsManagement(data: data);
      },
    ),
    GoRoute(
      path: RouteNames.customers,
      builder: (context, state) => CustomerManagement(),
    ),
    GoRoute(
      path: RouteNames.notFound,
      builder: (context, state) => NotFound(),
    ),
    GoRoute(
      path: RouteNames.printingPage,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return PrintPage(
          company: extra['company'] ?? 'N/A',
          amount: extra['amount'] ?? 'N/A',
          recipientName: extra['recipientName'] ?? 'N/A',
          senderName: extra['senderName'] ?? 'N/A',
          phoneNumber: extra['phoneNumber'] ?? 'N/A',
        );
      },
    ),
  ],
);
