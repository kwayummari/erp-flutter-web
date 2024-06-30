import 'package:erp/src/gateway/permissions.dart';
import 'package:erp/src/utils/app_const.dart';
import 'package:erp/src/widgets/app_button.dart';
import 'package:erp/src/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:erp/src/screens/models/layout/layout.dart';

class PermissionsManagement extends StatefulWidget {
  final Map<String, dynamic> data;
  const PermissionsManagement({super.key, required this.data});

  @override
  State<PermissionsManagement> createState() => _PermissionsManagementState();
}

class _PermissionsManagementState extends State<PermissionsManagement> {
  List permissionData = [];
  bool isLoading = true;
  bool hasError = false;
  Map<String, Map<String, dynamic>> selectedItems = {};

  Future<void> fetchData() async {
    try {
      permissionsServices permissionsService = permissionsServices();
      final permissionsResponse =
          await permissionsService.getPermissions(context, widget.data);
      if (permissionsResponse != null &&
          permissionsResponse['permissions'] != null) {
        setState(() {
          permissionData = permissionsResponse['permissions'];
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

  void handleCheckboxChange(int index, String typeValue) {
    setState(() {
      var id = permissionData[index]['id'];
      var itemKey = '$id-$typeValue';
      var item = {
        'id': id,
        'typeValue': typeValue,
        'status': permissionData[index][typeValue] == '1' ? '0' : '1'
      };

      if (selectedItems.containsKey(itemKey)) {
        selectedItems.remove(itemKey);
      } else {
        selectedItems[itemKey] = item;
      }

      permissionData[index][typeValue] =
          permissionData[index][typeValue] == '1' ? '0' : '1';
    });
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
            else if (permissionData.isNotEmpty)
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                    mainAxisExtent: 200,
                  ),
                  padding: EdgeInsets.all(10.0),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: permissionData.length,
                  itemBuilder: (context, index) {
                    return Material(
                      elevation: 10,
                      color: AppConst.white,
                      child: Container(
                        width: 350.0,
                        height: 200.0,
                        decoration: BoxDecoration(
                          color: AppConst.white,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: AppText(
                                  txt: permissionData[index]['name'],
                                  size: 15,
                                  color: AppConst.black,
                                  weight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Row(
                                children: [
                                  Checkbox(
                                    value: permissionData[index]['find'] == '1',
                                    onChanged: (bool? newValue) {
                                      handleCheckboxChange(index, 'find');
                                    },
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  AppText(
                                    txt: 'Get Data',
                                    size: 15,
                                    color: AppConst.black,
                                    weight: FontWeight.bold,
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Checkbox(
                                    value: permissionData[index]['increase'] ==
                                        '1',
                                    onChanged: (bool? newValue) {
                                      handleCheckboxChange(index, 'increase');
                                    },
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  AppText(
                                    txt: 'Post Data',
                                    size: 15,
                                    color: AppConst.black,
                                    weight: FontWeight.bold,
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Checkbox(
                                    value:
                                        permissionData[index]['upgrade'] == '1',
                                    onChanged: (bool? newValue) {
                                      handleCheckboxChange(index, 'upgrade');
                                    },
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  AppText(
                                    txt: 'Update Data',
                                    size: 15,
                                    color: AppConst.black,
                                    weight: FontWeight.bold,
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Checkbox(
                                    value:
                                        permissionData[index]['remove'] == '1',
                                    onChanged: (bool? newValue) {
                                      handleCheckboxChange(index, 'remove');
                                    },
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  AppText(
                                    txt: 'Delete Data',
                                    size: 15,
                                    color: AppConst.black,
                                    weight: FontWeight.bold,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: AppButton(
                    onPress: () async {
                      permissionsServices permissionsService =
                          permissionsServices();
                      final permissionsResponse = await permissionsService
                          .addPermission(context,
                              {'permissions': selectedItems.values.toList()});
                      selectedItems.clear();
                      fetchData();
                    },
                    label: 'Submit',
                    borderRadius: 5,
                    textColor: AppConst.white,
                    gradient: AppConst.primaryGradient,
                  )),
            )
          ],
        ),
      ),
    );
  }
}
