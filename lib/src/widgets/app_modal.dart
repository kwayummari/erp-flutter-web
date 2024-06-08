import 'package:flutter/material.dart';
import 'package:erp/src/widgets/app_text.dart';

class ReusableModal extends StatelessWidget {
  final String title;
  final Widget content;
  final Widget? footer;
  final double? width;
  final double? height;
  final Future<void> Function()? onClose;

  const ReusableModal({
    Key? key,
    required this.title,
    required this.content,
    this.footer,
    this.width,
    this.height,
    this.onClose,
  }) : super(key: key);

  static void show(
    BuildContext context,
    String title,
    Widget content, {
    Widget? footer,
    double? width,
    double? height,
    Future<void> Function()? onClose,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ReusableModal(
          title: title,
          content: content,
          footer: footer,
          width: width,
          height: height,
          onClose: onClose,
        );
      },
    ).then((value) async {
      if (onClose != null) {
        await onClose();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: [
              AppText(txt: title, size: 22, weight: FontWeight.bold),
              Spacer(),
              IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.cancel))
            ],
          ),
          SizedBox(height: 15),
          Expanded(
            child: content,
          ),
          SizedBox(height: 5),
          if (footer != null) footer!,
        ],
      ),
    );
  }
}
