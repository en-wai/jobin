import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/components/colors.dart';
import 'package:shopping_app/controllers/auth_controller.dart';
import 'package:shopping_app/controllers/location_controller.dart';
import 'package:shopping_app/controllers/popular_product.dart';
import 'package:shopping_app/controllers/product_controller.dart';
import 'package:get/get.dart';
import 'package:shopping_app/controllers/user_controller.dart';
import 'package:shopping_app/uitls/app_dimensions.dart';
import 'package:shopping_app/widgets/big_text.dart';
import 'package:shopping_app/widgets/text_widget.dart';

import 'main_food_page.dart';
class HomePageBody extends StatefulWidget {
  const HomePageBody({Key? key}) : super(key: key);

  @override
  _HomePageBodyState createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody> {
  ScrollController scrollController = ScrollController();
  double _scrollPosition=0;
  double _opacity=0;


  @override
  void initState(){
    super.initState();

    scrollController.addListener(() {
      setState(() {
        _scrollPosition=scrollController.position.pixels;
      });
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<void>_loadResources(bool reload)async {
    await  Get.find<ProductController>().getRecommendedProductList(reload);
    await  Get.find<PopularProduct>().getPopularProductList(reload);
    if(Get.find<AuthController>().isLoggedIn()) {
      await Get.find<UserController>().getUserInfo();

    }
  }


  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    _opacity = _scrollPosition < screenSize.height * 0.40
        ? _scrollPosition / (screenSize.height * 0.20)
        : 1;
    //this is to check if opacity is less than 0 or bigger than 1
    _opacity=_opacity<0?0:_opacity>1?1:_opacity;

    return RefreshIndicator(
         onRefresh: () async {
          await _loadResources(true);
         },
         child: Column(
            children: [
              Container(
                color: Colors.white.withOpacity(_opacity),
                child: Container(
                  //if we set bottom to topBar on mobile we will get 60
                  margin:  EdgeInsets.only(top:Dimensions.topBar, bottom: 15),
                  height: 55,
                  padding:  EdgeInsets.only( left: Dimensions.appMargin, right: Dimensions.appMargin),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          BigText(text: "Bangladesh", color: AppColors.mainColor),
                          Row(
                            children: [
                              TextWidget(text: "Narshingdi", color: Colors.black54),
                              Icon(Icons.arrow_drop_down_rounded, )
                            ],
                          )
                        ],
                      ),
                      Center(
                        child: Container(
                          width: Dimensions.iconBackSize,
                          height: Dimensions.iconBackSize,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.borderRadius15),
                              color: AppColors.mainColor
                          ),
                          child: Icon(Icons.search, color:Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                  child: SingleChildScrollView(
                      controller: scrollController,
                      child:  MainFoodPage())),
            ],
      ),
       );


  }
}
