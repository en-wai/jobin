import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_app/base/go_to_sign_in_page.dart';
import 'package:shopping_app/components/colors.dart';
import 'package:shopping_app/controllers/auth_controller.dart';
import 'package:shopping_app/controllers/cart_controller.dart';
import 'package:shopping_app/controllers/location_controller.dart';
import 'package:shopping_app/controllers/user_controller.dart';
import 'package:shopping_app/routes/route_helper.dart';
import 'package:shopping_app/uitls/app_dimensions.dart';
import 'package:shopping_app/widgets/account_widgets.dart';
import 'package:get/get.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  _loadUserInfo() async {
    await Get.find<LocationController>().getAddressList();
    if (Get.find<LocationController>().addressList.isNotEmpty) {
      var address = Get.find<LocationController>().addressList[0];
      await Get.find<LocationController>().saveUserAddress(address);
      print("I am in home page ............");
    } else {
      print("addresslist is empty");
    }
  }

  @override
  Widget build(BuildContext context) {
    bool _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    if (_isLoggedIn && Get.find<LocationController>().addressList.isEmpty) {
      Get.find<UserController>().getUserInfo();
      // Get.find<LocationController>().getAddressList();
      _loadUserInfo();
      print(".........");
    } else {
      print("empty" + _isLoggedIn.toString());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: AppColors.mainColor,
      ),
      backgroundColor: Colors.white10,
      body: Container(
        margin: Dimensions.isWeb
            ? EdgeInsets.only(
                left: Dimensions.MARGIN_SIZE_EXTRA_LARGE,
                right: Dimensions.MARGIN_SIZE_EXTRA_LARGE)
            : EdgeInsets.all(0),
        child: GetBuilder<UserController>(builder: (userController) {
          return (_isLoggedIn)
              ? (userController.isLoading == true
                  ? Column(

                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 150,
                          height: 150,
                          child: Icon(
                            Icons.person,
                            size: 75,
                            color: Colors.white,
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(75),
                              color: AppColors.mainColor),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: Scrollbar(
                            child: SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              child: Column(
                                children: [

                                  SizedBox(
                                    height: 20,
                                  ),
                                  AccountWidgets(
                                      userController.userInfoModel.fName,
                                      icon: Icons.person,
                                      backgroundColor: AppColors.mainColor),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  AccountWidgets(
                                      userController.userInfoModel.phone,
                                      icon: Icons.phone,
                                      backgroundColor: AppColors.yellowColor),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  AccountWidgets(
                                      userController.userInfoModel.email,
                                      icon: Icons.email,
                                      backgroundColor: AppColors.yellowColor),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  GetBuilder<LocationController>(
                                      builder: (locationController) {
                                    if (_isLoggedIn &&
                                        Get.find<LocationController>()
                                            .addressList
                                            .isEmpty) {
                                      return GestureDetector(
                                        onTap: () {
                                          Get.toNamed(
                                              RouteHelper.getAddAddressRoute());
                                        },
                                        child: AccountWidgets(
                                            "Fil in your address",
                                            icon: Icons.location_on,
                                            backgroundColor:
                                                AppColors.yellowColor),
                                      );
                                    } else {
                                      return GestureDetector(
                                        onTap: () {
                                          Get.toNamed(
                                              RouteHelper.getAddAddressRoute());
                                        },
                                        child: AccountWidgets("Address",
                                            icon: Icons.location_on,
                                            backgroundColor:
                                                AppColors.yellowColor),
                                      );
                                    }
                                  }),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  AccountWidgets("none",
                                      icon: Icons.message,
                                      backgroundColor: Colors.redAccent),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  InkWell(
                                      onTap: () {
                                        if (Get.find<AuthController>()
                                            .isLoggedIn()) {
                                          Get.find<AuthController>()
                                              .clearSharedData();
                                          Get.find<CartController>()
                                              .clearCartList();
                                          Get.find<LocationController>()
                                              .clearAddressList();
                                          Get.offAllNamed(
                                              RouteHelper.getInitialRoute());
                                        }
                                      },
                                      child: AccountWidgets("Log out",
                                          icon: Icons.logout,
                                          backgroundColor: Colors.redAccent)),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  : CircularProgressIndicator())
              : GoToSignInPage();

        }),
      ),
    );
  }
}
