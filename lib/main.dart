// ignore_for_file: prefer_const_constructors
import 'package:erp/src/utils/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:erp/src/functions/createMaterialColor.dart';
import 'package:erp/src/utils/app_const.dart';
import 'package:provider/provider.dart';
import 'package:erp/src/provider/providers.dart';
import 'package:responsive_framework/responsive_framework.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => MultiProvider(
      providers: MyProviderList.providers,
      child: MaterialApp.router(
        routerConfig: router,
        builder: (context, widget) => ResponsiveBreakpoints.builder(
          breakpoints: const [
            const Breakpoint(start: 0, end: 480, name: MOBILE),
            const Breakpoint(start: 481, end: 800, name: TABLET),
            const Breakpoint(start: 801, end: 1920, name: DESKTOP),
            const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
          ],
          child: widget!
        ),
        debugShowCheckedModeBanner: false,
        title: 'JAMSOLUTIONS',
        theme: ThemeData(
            cardColor: AppConst.primary,
            highlightColor: AppConst.primary,
            splashColor: AppConst.primary,
            primaryColor: AppConst.primary,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: createMaterialColor(AppConst.primary),
            ).copyWith(surface: AppConst.primary)),
      ));
}
