import 'package:flutter/material.dart';

class CustomPopover extends StatelessWidget {
  final IconData icon;
  final List<CustomPopoverItem> items;

  const CustomPopover({Key? key, required this.icon, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<CustomPopoverItem>(
      icon: Icon(icon),
      itemBuilder: (BuildContext context) => items.map((item) {
        return PopupMenuItem<CustomPopoverItem>(
          value: item,
          child: Row(
            children: [
              Icon(item.icon),
              SizedBox(width: 10),
              Text(item.title),
            ],
          ),
        );
      }).toList(),
      onSelected: (CustomPopoverItem item) {
        item.onTap();
      },
    );
  }
}

class CustomPopoverItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  CustomPopoverItem({required this.title, required this.icon, required this.onTap});
}
