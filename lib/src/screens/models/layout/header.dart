import 'package:erp/src/utils/app_const.dart';
import 'package:erp/src/utils/routes/route-names.dart';
import 'package:erp/src/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
      height: MediaQuery.of(context).size.height,
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
              GestureDetector(
                  onTap: () => null,
                  child: Badge(
                    child: Icon(
                      Icons.person,
                      color: AppConst.black,
                    ),
                  )),
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