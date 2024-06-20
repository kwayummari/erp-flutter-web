import 'package:erp/src/utils/app_const.dart';
import 'package:flutter/material.dart';
import 'package:erp/src/gateway/rolesService.dart';
import 'package:erp/src/widgets/app_text.dart';
import 'package:erp/src/screens/models/layout/layout.dart';

class rolesManagement extends StatefulWidget {
  const rolesManagement({super.key});

  @override
  State<rolesManagement> createState() => _rolesManagementState();
}

class _rolesManagementState extends State<rolesManagement> {
  List rolesData = [];
  bool isLoading = true;
  bool hasError = false;

  Future<void> fetchData() async {
    try {
      rolesServices rolesService = rolesServices();
      final rolesResponse = await rolesService.getRoles(context);
      if (rolesResponse != null && rolesResponse['roles'] != null) {
        setState(() {
          rolesData = rolesResponse['roles'];
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
                    crossAxisCount: 5, // Adjust based on available space and design
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                    mainAxisExtent: 70,
                  ),
                  padding: EdgeInsets.all(10.0),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: rolesData.length + 1, // Add one for the Add Role button
                  itemBuilder: (context, index) {
                    if (index == rolesData.length) {
                      return Material(
                        elevation: 10,
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          width: 200, // Fixed width for each grid item
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {}, 
                                  icon: Icon(Icons.add, color: AppConst.white,),
                                ),
                                SizedBox(width: 20,),
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
                      );
                    } else {
                      // Normal grid item
                      return Material(
                        elevation: 10,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          width: 200, // Fixed width for each grid item
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
                                IconButton(
                                  onPressed: () {}, 
                                  icon: Icon(Icons.more_vert)
                                ),
                              ],
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
