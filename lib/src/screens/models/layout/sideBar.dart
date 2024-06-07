import 'package:erp/src/gateway/menu.dart';
import 'package:erp/src/utils/app_const.dart';
import 'package:flutter/material.dart';

class sideBar extends StatefulWidget {
  const sideBar({super.key});

  @override
  State<sideBar> createState() => _sideBarState();
}

class _sideBarState extends State<sideBar> {
  List data = [];

  void fetchData() async {
    menuServices menuService =
        menuServices();
    final datas = await menuService.getMenu(context);
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
      width: 250,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                gradient: AppConst.primaryGradient,
                borderRadius: BorderRadius.circular(0.0),),
                child: Column(
                  children: [

                  ],
                ),
    );
  }
}