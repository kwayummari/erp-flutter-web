import 'package:shared_preferences/shared_preferences.dart';

Future<bool> isUserLoggedIn() async {
  final prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.containsKey('email') &&
                    prefs.containsKey('userId') &&
                    prefs.containsKey('companyId') &&
                    prefs.containsKey('roleId') &&
                    prefs.containsKey('fullname') &&
                    prefs.containsKey('branchId');
  return isLoggedIn;
}
