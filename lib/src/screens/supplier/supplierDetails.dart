import 'package:erp/src/gateway/supplierService.dart';
import 'package:flutter/material.dart';

class SupplierDetails extends StatefulWidget {
  final String id;
  const SupplierDetails({
    super.key,
    required this.id,
  });

  @override
  State<SupplierDetails> createState() => _SupplierDetailsState();
}

class _SupplierDetailsState extends State<SupplierDetails> {
  List<Map<String, dynamic>> productData = [];
  Future<void> fetchData() async {
    try {
      supplierServices supplierService = supplierServices();
      final productResponse =
          await supplierService.getSupplierDetails(context, widget.id);
      print(productResponse);
      setState(() {
        productData = productResponse['suppliersDetails'];
      });
      print(productResponse);
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      child: productData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: productData.length,
              itemBuilder: (context, index) {
                final item = productData[index];
                return ListTile(
                  title: Text(item['name'] ?? 'No Name'),
                  subtitle: Text('Price: ${item['price'] ?? 'N/A'}'),
                  trailing: Text('Quantity: ${item['quantity'] ?? 'N/A'}'),
                );
              },
            ),
    );
  }
}
