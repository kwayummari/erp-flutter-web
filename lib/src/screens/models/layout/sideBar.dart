import 'package:erp/src/gateway/menu.dart';
import 'package:erp/src/utils/app_const.dart';
import 'package:erp/src/utils/routes/route-names.dart';
import 'package:erp/src/widgets/app_expanding_card.dart';
import 'package:erp/src/widgets/app_listview_builder.dart';
import 'package:erp/src/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class sideBar extends StatefulWidget {
  const sideBar({super.key});

  @override
  State<sideBar> createState() => _sideBarState();
}

class _sideBarState extends State<sideBar> {
  List data = [];

  void fetchData() async {
    menuServices menuService = menuServices();
    final datas = await menuService.getMenu(context);
    setState(() {
      data = datas['permissions'];
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 310,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: AppConst.black,
        borderRadius: BorderRadius.circular(0.0),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
            height: 50,
            child: AppText(
              txt: 'ERP SYSTEM',
              size: 20,
              color: AppConst.white,
              weight: FontWeight.bold,
            ),
          ),
          GestureDetector(
            onTap: () {
              context.go(RouteNames.dashboard);
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Card(
                color: AppConst.transparent,
                elevation: 16.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(children: [
                  ListTile(
                    title: Row(
                      children: [
                        AppText(
                          txt: 'Dashboard',
                          size: 15,
                          color: AppConst.white,
                        )
                      ],
                    ),
                    leading: Icon(
                      Icons.home,
                      color: AppConst.white,
                    ),
                  ),
                ]),
              ),
            ),
          ),
          if (data.isNotEmpty)
            Expanded(
              child: AppListviewBuilder(
                  itemnumber: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    List subMenu = data[index]['submenu'];
                    return data[index]['find'] == '1'
                        ? ExpandableCard(
                            title: data[index]['name'],
                            children: [
                              if (subMenu.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(left: 40),
                                  child: AppListviewBuilder(
                                      itemnumber: subMenu.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return GestureDetector(
                                          onTap: () {
                                            if (subMenu[index]['url'] ==
                                                'user') {
                                              context.go(
                                                  RouteNames.userManagement);
                                            } else if (subMenu[index]['url'] ==
                                                'inventory') {
                                              context.go(RouteNames.inventory);
                                            } else if (subMenu[index]['url'] ==
                                                'supplier') {
                                              context.go(RouteNames.supplier);
                                            } else if (subMenu[index]['url'] ==
                                                'purchase') {
                                              context
                                                  .go(RouteNames.purchaseOrder);
                                            }
                                          },
                                          child: ListTile(
                                            title: AppText(
                                              txt: subMenu[index]['name'],
                                              size: 15,
                                              color: AppConst.white,
                                            ),
                                          ),
                                        );
                                      }),
                                )
                            ],
                          )
                        : Container();
                  }),
            ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Card(
              color: AppConst.transparent,
              elevation: 16.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ExpansionTile(
                iconColor: AppConst.white,
                collapsedIconColor: AppConst.white,
                title: Row(
                  children: [
                    AppText(
                      txt: 'Configurations',
                      size: 15,
                      color: AppConst.white,
                    )
                  ],
                ),
                leading: Icon(
                  Icons.settings,
                  color: AppConst.white,
                ),
                children: <Widget>[
                  ListTile(
                    onTap: () {
                      context.go(RouteNames.roles);
                    },
                    title: AppText(
                      txt: 'Roles',
                      size: 15,
                      color: AppConst.white,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      context.go(RouteNames.branch);
                    },
                    title: AppText(
                      txt: 'Branch',
                      size: 15,
                      color: AppConst.white,
                    ),
                  ),
                  // Add more children as needed
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Card(
              color: AppConst.transparent,
              elevation: 16.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                onTap: () {
                  context.go(RouteNames.dashboard);
                },
                title: Row(
                  children: [
                    AppText(
                      txt: 'Docs',
                      size: 15,
                      color: AppConst.white,
                    )
                  ],
                ),
                leading: Icon(
                  Icons.document_scanner,
                  color: AppConst.white,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Card(
              color: AppConst.transparent,
              elevation: 16.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                onTap: () {
                  context.go(RouteNames.dashboard);
                },
                title: Row(
                  children: [
                    AppText(
                      txt: 'Contact JamSolutions',
                      size: 15,
                      color: AppConst.white,
                    )
                  ],
                ),
                leading: Icon(
                  Icons.contact_support,
                  color: AppConst.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
