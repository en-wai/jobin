
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/screens/checkout/payment_failed_dialogue.dart';
import 'package:shopping_app/uitls/app_dimensions.dart';

import '../../base/custom_button.dart';
import 'package:get/get.dart';

import '../../routes/route_helper.dart';
import '../../uitls/styles.dart';
class OrderSuccessfulScreen extends StatelessWidget {
  final String orderID;
  final int status;
  OrderSuccessfulScreen({required this.orderID, required this.status});

  @override
  Widget build(BuildContext context) {
    if(status == 0) {
      Future.delayed(Duration(seconds: 1), () {
        Get.dialog(PaymentFailedDialog(orderID: orderID), barrierDismissible: false);
      });
    }
    return Scaffold(

      body: Center(child: SizedBox(width: Dimensions.WEB_MAX_WIDTH, child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

        Image.asset(status == 1 ? "assets/image/checked.png" : "assets/image/warning.png", width: 100, height: 100),
        SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

        Text(
          status == 1 ? 'You placed the order successfully' : 'Your order failed',
          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
        ),
        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE, vertical: Dimensions.PADDING_SIZE_SMALL),
          child: Text(
            status == 1 ? 'Successful order' : 'Failed order',
            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 30),

        Padding(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          child: CustomButton(buttonText: 'Back to Home'.tr, onPressed: () => Get.offAllNamed(RouteHelper.getInitialRoute())),
        ),
      ]))),
    );
  }
}
