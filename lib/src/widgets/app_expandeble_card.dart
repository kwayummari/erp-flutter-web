// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class ExpandableCard extends StatefulWidget {
  final String title;
  final String subTitle;
  final String disbursed;
  final List<Widget> children;

  const ExpandableCard({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.children,
    required this.disbursed,
  }) : super(key: key);

  @override
  _ExpandableCardState createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<ExpandableCard> {
  bool _isExpanded = false;

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleExpanded,
      child: Card(
        elevation: 16.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            ListTile(
              title: Row(
                children: [
                  Text(widget.title,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    widget.disbursed == 'true' ? ' (Disbursed)' : ' (Pending)',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: widget.disbursed == 'true'
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ],
              ),
              subtitle: Text(widget.subTitle,
                  style: const TextStyle(fontWeight: FontWeight.normal)),
              trailing: IconButton(
                icon: Icon(
                  _isExpanded ? Icons.expand_less : Icons.expand_more,
                ),
                onPressed: _toggleExpanded,
              ),
            ),
            if (_isExpanded)
              Column(
                children: widget.children,
              ),
          ],
        ),
      ),
    );
  }
}
