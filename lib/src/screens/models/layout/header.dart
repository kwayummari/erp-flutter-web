import 'package:erp/src/utils/app_const.dart';
import 'package:erp/src/utils/routes/route-names.dart';
import 'package:erp/src/widgets/app-dropdownV2.dart';
import 'package:erp/src/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Header extends StatefulWidget {
  final Widget child;
  const Header({super.key, required this.child});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  late String pageName;
  @override
  void initState() {
    super.initState();
    final uri = Uri.base;
    pageName = uri.fragment.replaceFirst('/', '');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 310,
      height: MediaQuery.of(context).size.height + 100,
      decoration: BoxDecoration(
        color: AppConst.white,
        borderRadius: BorderRadius.circular(0.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              SizedBox(
                width: 20,
              ),
              Icon(
                Icons.menu,
                color: AppConst.black,
              ),
              SizedBox(
                width: 20,
              ),
              GestureDetector(
                  onTap: () => null,
                  child: AppText(
                    txt: pageName,
                    size: 18,
                    color: AppConst.black,
                  )),
              Spacer(),
              GestureDetector(
                  onTap: () => null,
                  child: Badge(
                    label: Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: AppConst.red),
                        child: Center(
                            child: AppText(
                          txt: '20',
                          size: 8,
                          color: AppConst.white,
                          weight: FontWeight.bold,
                        ))),
                    child: Icon(
                      Icons.notifications_none,
                      color: AppConst.black,
                    ),
                  )),
              SizedBox(
                width: 20,
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: PopupMenuButton<String>(
                  onSelected: (value) async {
                    if (value == 'Logout') {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.remove('email');
                      await prefs.remove('userId');
                      await prefs.remove('companyId');
                      await prefs.remove('roleId');
                      await prefs.remove('fullname');
                      await prefs.remove('branchId');
                      GoRouter.of(context).go('/login');
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/login',
                        (Route<dynamic> route) => false,
                      );
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'Profile',
                        child: Text('Profile'),
                      ),
                      PopupMenuItem<String>(
                        value: 'Settings',
                        child: Text('Settings'),
                      ),
                      PopupMenuItem<String>(
                        value: 'Branch',
                        child: SizedBox(
                          width: 200,
                          child: DropdownTextFormFieldV2(
                            labelText: 'Select Branch',
                            fillcolor: AppConst.white,
                            apiUrl: 'getBranch',
                            textsColor: AppConst.black,
                            dropdownColor: AppConst.white,
                            dataOrigin: 'branch',
                            onChanged: (value, data) async {
                              int selectedId = int.parse(value ?? '1');
                              var selectedBranch = data.firstWhere(
                                (branch) => branch['id'] == selectedId,
                                orElse: () => <String, dynamic>{},
                              );
                              if (selectedBranch.isNotEmpty) {
                                final prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setString(
                                    'fetchingBranchId', selectedId.toString());
                                await prefs.setString('fetchingBranchName',
                                    selectedBranch['name'].toString());
                                context.go(RouteNames.splash);
                              } else {
                                print('Branch not found');
                              }
                            },
                            valueField: 'id',
                            displayField: 'name',
                            // displayField2: 'description',
                            allData: [],
                          ),
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'Logout',
                        child: Text('Logout'),
                      ),
                    ];
                  },
                  child: Badge(
                    child: Icon(
                      Icons.person,
                      color: AppConst.black,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Divider(
            color: AppConst.grey,
            height: 1,
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              SizedBox(
                width: 20,
              ),
              GestureDetector(
                  onTap: () => context.go(RouteNames.dashboard),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: AppText(
                      txt: 'Home /',
                      size: 18,
                      color: AppConst.grey,
                    ),
                  )),
              SizedBox(
                width: 20,
              ),
              GestureDetector(
                  onTap: () => context.go(RouteNames.dashboard),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: AppText(
                      txt: 'Library /',
                      size: 18,
                      color: AppConst.grey,
                    ),
                  )),
              SizedBox(
                width: 20,
              ),
              GestureDetector(
                  onTap: () => null,
                  child: AppText(
                    txt: pageName,
                    size: 18,
                    color: AppConst.grey,
                  )),
              Spacer(),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Divider(
            color: AppConst.grey,
            height: 1,
          ),
          SizedBox(
            height: 40,
          ),
          widget.child
        ],
      ),
    );
  }
}
