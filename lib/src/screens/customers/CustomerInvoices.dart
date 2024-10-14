import 'package:erp/src/gateway/supplierService.dart';
import 'package:flutter/material.dart';

class CustomerInvoices extends StatefulWidget {
  final String customerId;
  const CustomerInvoices({
    super.key,
    required this.customerId,
  });

  @override
  State<CustomerInvoices> createState() => _CustomerInvoicesState();
}

class _CustomerInvoicesState extends State<CustomerInvoices> {
  List<Map<String, dynamic>> invoiceData = [];

  Future<void> fetchData() async {
    try {
      supplierServices supplierService = supplierServices();
      final invoicesResponse =
          await supplierService.getCustomerInvoices(context, widget.customerId);
      print(invoicesResponse);
      if (mounted) {
        setState(() {
          invoiceData = List<Map<String, dynamic>>.from(
              invoicesResponse['customerInvoices'] ?? []);
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      child: invoiceData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: invoiceData.length,
              itemBuilder: (context, index) {
                final item = invoiceData[index];
                final List<dynamic> products = item['items'] ?? [];

                return Card(
                  child: ExpansionTile(
                    title: Text('Receipt No: ${item['receiptNo'] ?? 'N/A'}'),
                    subtitle: Text(
                        'Payment Method: Payment by credit, Status: Pending'),
                        // trailing: ,
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: products.length,
                        itemBuilder: (context, productIndex) {
                          final product = products[productIndex];
                          return ListTile(
                            title: Text(product['name'] ?? 'No Product Name'),
                            subtitle: Text(
                                'Price: ${product['sellingPrice'] ?? 'N/A'}'),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
