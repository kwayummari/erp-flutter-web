// ignore_for_file: library_private_types_in_public_api

import 'package:erp/src/utils/app_const.dart';
import 'package:erp/src/widgets/app_text.dart';
import 'package:flutter/material.dart';

class ExpandableCard extends StatefulWidget {
  final String title;
  final List<Widget> children;

  const ExpandableCard({
    Key? key,
    required this.title,
    required this.children,
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
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Card(
          color: AppConst.transparent,
          elevation: 16.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              ListTile(
                title: Row(
                  children: [
                    AppText(
                      txt: widget.title,
                      size: 15,
                      color: AppConst.white,
                    )
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: AppConst.white,
                  ),
                  onPressed: _toggleExpanded,
                ),
                leading: Icon(Icons.folder, color: AppConst.white,),
              ),
              if (_isExpanded)
                Column(
                  children: widget.children,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
