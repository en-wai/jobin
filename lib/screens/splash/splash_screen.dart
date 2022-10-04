import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shopping_app/controllers/auth_controller.dart';
import 'package:shopping_app/controllers/cart_controller.dart';
import 'package:shopping_app/controllers/location_controller.dart';
import 'package:shopping_app/controllers/popular_product.dart';
import 'package:shopping_app/controllers/product_controller.dart';
import 'package:shopping_app/controllers/user_controller.dart';
import 'package:shopping_app/routes/route_helper.dart';
import 'package:shopping_app/screens/home/home_page.dart';
import 'package:get/get.dart';
import 'package:shopping_app/uitls/app_dimensions.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin{
  late Animation<double> animation;
  late AnimationController _controller;
  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override

  Future<void>_loadResources(bool reload)async {
    await  Get.find<ProductController>().getRecommendedProductList(reload);
    await  Get.find<PopularProduct>().getPopularProductList(reload);
    if(Get.find<AuthController>().isLoggedIn()) {
      await Get.find<UserController>().getUserInfo();
      await Get.find<LocationController>().getAddressList();
      if(Get.find<LocationController>().addressList.isNotEmpty){
        var address = Get.find<LocationController>().addressList[0];
        await Get.find<LocationController>().saveUserAddress(address);
        print("I am in splash page ............");
      }
    }
  }
  void _removeResource(){
     Get.find<CartController>().clear();
     Get.find<CartController>().removeCartSharedPreference();
  }

  void initState() {
    super.initState();
    _loadResources(true);
    _removeResource();
    _controller =
    new AnimationController(vsync: this, duration: Duration(seconds: 2))..forward()
      ;
    animation = new CurvedAnimation(parent: _controller,
        curve: Curves.linear);
    Timer(Duration(seconds: 3),

        ()=>Get.offNamed(RouteHelper.getInitialRoute())
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        //crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: animation,
              child: Center(child: Image.asset("img/logo part 1.png", width:Dimensions.SPLASH_IMG_WIDTH))),
          Center(child: Image.asset("img/logo part 2.png", width:Dimensions.SPLASH_IMG_WIDTH,)),
        ],
      ),
    );
  }
}
