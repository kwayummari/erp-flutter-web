import 'package:erp/src/utils/app_const.dart';
import 'package:erp/src/widgets/app_listTile.dart';
import 'package:erp/src/widgets/app_listview_builder.dart';
import 'package:erp/src/widgets/app_text.dart';
import 'package:flutter/material.dart';

class ItemSales extends StatefulWidget {
  final List sales;
  const ItemSales({super.key, required this.sales});

  @override
  State<ItemSales> createState() => _ItemSalesState();
}

class _ItemSalesState extends State<ItemSales> {
  List<Map<String, dynamic>> salesData = [];
  bool isLoading = true;
  bool hasError = false;
  List salesItems = [];

  @override
  Widget build(BuildContext context) {
    return  widget.sales.isEmpty
                ? const Center(child: Text('No sales data available'))
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 400,
                      child: AppListviewBuilder(
                        itemnumber: widget.sales.length,
                        direction: Axis.vertical,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Material(
                              elevation: 4,
                              child: AppListTile(
                                title: AppText(
                                  txt:
                                      'Name: ${widget.sales[index]['productName']}',
                                  size: 20,
                                  color: AppConst.black,
                                  weight: FontWeight.bold,
                                ),
                                subTitle: AppText(
                                    txt:
                                        'Amount: ${widget.sales[index]['quantity']}',
                                    size: 15),
                                trailing: AppText(
                                  txt:
                                      'Product Number: ${widget.sales[index]['productNumber']}',
                                  size: 15,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
  }
}
