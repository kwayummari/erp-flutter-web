import 'package:provider/provider.dart';
import 'package:erp/src/provider/loadingProvider.dart';
import 'package:erp/src/provider/rowProvider.dart';

class MyProviderList {
  static List<ChangeNotifierProvider> providers = [
    ChangeNotifierProvider<LoadingProvider>(create: (context) => LoadingProvider()),
    ChangeNotifierProvider<RowDataProvider>(
        create: (context) => RowDataProvider()),
    // Add other providers here
  ];
}
