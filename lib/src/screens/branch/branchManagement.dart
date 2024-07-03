import 'package:erp/src/gateway/branchServices.dart';
import 'package:erp/src/screens/branch/addBranch.dart';
import 'package:erp/src/screens/roles/editRolesForm.dart';
import 'package:erp/src/utils/app_const.dart';
import 'package:erp/src/utils/routes/route-names.dart';
import 'package:erp/src/widgets/app_button.dart';
import 'package:erp/src/widgets/app_modal.dart';
import 'package:erp/src/widgets/app_popover.dart';
import 'package:flutter/material.dart';
import 'package:erp/src/gateway/rolesService.dart';
import 'package:erp/src/widgets/app_text.dart';
import 'package:erp/src/screens/models/layout/layout.dart';
import 'package:go_router/go_router.dart';

class branchManagement extends StatefulWidget {
  const branchManagement({super.key});

  @override
  State<branchManagement> createState() => _branchManagementState();
}

class _branchManagementState extends State<branchManagement> {
  List rolesData = [];
  bool isLoading = true;
  bool hasError = false;

  Future<void> fetchData() async {
    try {
      branchServices branchService = branchServices();
      final branchResponse = await branchService.getBranch(context);
      if (branchResponse != null && branchResponse['branch'] != null) {
        setState(() {
          rolesData = branchResponse['branch'];
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return layout(
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (isLoading)
              Center(child: CircularProgressIndicator())
            else if (hasError)
              Center(child: Text('Error loading data'))
            else if (rolesData.isNotEmpty)
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        5,
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                    mainAxisExtent: 70,
                  ),
                  padding: EdgeInsets.all(10.0),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount:
                      rolesData.length + 1,
                  itemBuilder: (context, index) {
                    if (index == rolesData.length) {
                      return MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            ReusableModal.show(
                              width: 500,
                              height: 300,
                              context,
                              AppText(
                                  txt: 'Add Role',
                                  size: 22,
                                  weight: FontWeight.bold),
                              onClose: fetchData,
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  addBranchForm(fetchData: fetchData)
                                ],
                              ),
                              footer: AppButton(
                                  onPress: () {
                                    Navigator.pop(context);
                                  },
                                  solidColor: AppConst.black,
                                  label: 'Cancel',
                                  borderRadius: 5,
                                  textColor: AppConst.white),
                            );
                          },
                          child: Material(
                            elevation: 10,
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10.0),
                            child: Container(
                              width: 200,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color: AppConst.white,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    AppText(
                                      txt: ' Add Role',
                                      size: 20,
                                      color: Colors.white,
                                      weight: FontWeight.bold,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      // Normal grid item
                      return GestureDetector(
                        onTap: () {
                          final data = {
                            'id': rolesData[index]['id'].toString(),
                          };
                          context.go(
                            RouteNames.permissions,
                            extra: data,
                          );
                        },
                        child: Material(
                          elevation: 10,
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          child: Container(
                            width: 200,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  AppText(
                                    txt: rolesData[index]['name'],
                                    size: 20,
                                    color: Colors.black,
                                    weight: FontWeight.bold,
                                  ),
                                  Spacer(),
                                  CustomPopover(
                                    icon: Icons.more_vert,
                                    items: [
                                      CustomPopoverItem(
                                        title: 'Edit',
                                        icon: Icons.edit,
                                        onTap: () {
                                          Map<String, dynamic> data = {
                                            'name': rolesData[index]['name'],
                                            'id': rolesData[index]['id']
                                          };
                                          ReusableModal.show(
                                            width: 300,
                                            height: 300,
                                            context,
                                            AppText(
                                                txt: 'Edit Role',
                                                size: 18,
                                                weight: FontWeight.bold),
                                            onClose: fetchData,
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                editRole(
                                                    fetchData: fetchData,
                                                    data: data)
                                              ],
                                            ),
                                            footer: Row(
                                              children: [],
                                            ),
                                          );
                                        },
                                      ),
                                      CustomPopoverItem(
                                        title: 'Delete',
                                        icon: Icons.delete,
                                        onTap: () {
                                          ReusableModal.show(
                                            width: 300,
                                            height: 300,
                                            context,
                                            AppText(
                                                txt: 'Delete Role',
                                                size: 18,
                                                weight: FontWeight.bold),
                                            onClose: fetchData,
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Icon(
                                                  Icons.error,
                                                  color: AppConst.red,
                                                  size: 100,
                                                ),
                                                Container(
                                                  width: 240,
                                                  height: 50,
                                                  child: AppButton(
                                                      onPress: () async {
                                                        rolesServices
                                                            roleService =
                                                            rolesServices();
                                                        await roleService
                                                            .deleteRole(
                                                                context,
                                                                rolesData[index]
                                                                        ['id']
                                                                    .toString());
                                                        fetchData();
                                                        Navigator.pop(context);
                                                      },
                                                      gradient: AppConst
                                                          .primaryGradient,
                                                      label: 'Delete',
                                                      borderRadius: 5,
                                                      textColor:
                                                          AppConst.white),
                                                ),
                                              ],
                                            ),
                                            footer: Row(
                                              children: [],
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
