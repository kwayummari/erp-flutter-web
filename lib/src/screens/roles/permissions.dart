import 'package:erp/src/gateway/permissions.dart';
import 'package:erp/src/utils/app_const.dart';
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

  Future<void> fetchData() async {
    try {
      permissionsServices permissionsService = permissionsServices();
      final permissionsResponse =
          await permissionsService.getPermissions(context, widget.data);
      if (permissionsResponse != null &&
          permissionsResponse['permissions'] != null) {
        setState(() {
          permissionData = permissionsResponse['permissions'];
          print(permissionData);
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
            else if (permissionData.isNotEmpty)
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        5, // Adjust based on available space and design
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                    mainAxisExtent: 70,
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
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: AppText(
                          txt: permissionData[index]['name'],
                          size: 15,
                          color: AppConst.black,
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
