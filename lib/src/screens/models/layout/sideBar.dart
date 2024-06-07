import 'package:erp/src/gateway/menu.dart';
import 'package:erp/src/utils/app_const.dart';
import 'package:erp/src/widgets/app_expandeble_card.dart';
import 'package:erp/src/widgets/app_listview_builder.dart';
import 'package:erp/src/widgets/app_text.dart';
import 'package:flutter/material.dart';

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
    print(datas);
    setState(() {
      data = datas['contents'];
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
        gradient: AppConst.primaryGradient,
        borderRadius: BorderRadius.circular(0.0),
      ),
      child: Column(
        children: [
          SizedBox(height: 20,),
          Container(
            height: 50,
            
            child: AppText(txt: 'ERP SYSTEM', size: 20, color: AppConst.white, weight: FontWeight.bold,),
          ),
          if (data.isNotEmpty)
            Expanded(
              child: AppListviewBuilder(
                  itemnumber: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    List subMenu = data[index]['submenu'];
                    return ExpandableCard(
                      title: data[index]['name'],
                      children: [
                        if(data[index]['find'] == '1' && subMenu.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: 40),
                          child: AppListviewBuilder(
                              itemnumber: subMenu.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                  title: AppText(
                                    txt: subMenu[index]['name'],
                                    size: 15,
                                    color: AppConst.white,
                                  ),
                                );
                              }),
                        )
                      ],
                    );
                  }),
            ),
        ],
      ),
    );
  }
}
