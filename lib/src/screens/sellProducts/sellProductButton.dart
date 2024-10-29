import 'package:erp/src/utils/app_const.dart';
import 'package:erp/src/widgets/app_text.dart';
import 'package:flutter/material.dart';

class SellProductButton extends StatelessWidget {
  final void Function()? showCartPopup;
  const SellProductButton({super.key, required this.showCartPopup});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: showCartPopup,
      child: Material(
        elevation: 10,
        color: Colors.grey,
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          width: 200,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Spacer(),
                Icon(Icons.sell, color: AppConst.white),
                SizedBox(width: 20),
                AppText(
                    txt: 'Sell',
                    size: 30,
                    align: TextAlign.center,
                    color: Colors.white,
                    weight: FontWeight.bold),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
