import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_app/base/custom_loader.dart';
import 'package:shopping_app/base/custom_snackbar.dart';
import 'package:shopping_app/base/no_data_found.dart';
import 'package:shopping_app/components/colors.dart';
import 'package:shopping_app/controllers/auth_controller.dart';
import 'package:shopping_app/controllers/cart_controller.dart';
import 'package:shopping_app/controllers/location_controller.dart';
import 'package:shopping_app/controllers/popular_product.dart';
import 'package:shopping_app/controllers/product_controller.dart';
import 'package:shopping_app/controllers/user_controller.dart';
import 'package:shopping_app/data/repos/order_controller.dart';
import 'package:shopping_app/models/cart_item.dart';
import 'package:shopping_app/models/place_order.dart';
import 'package:shopping_app/routes/route_helper.dart';
import 'package:shopping_app/uitls/app_constants.dart';
import 'package:shopping_app/uitls/app_dimensions.dart';
import 'package:shopping_app/widgets/big_text.dart';
import 'package:shopping_app/widgets/text_widget.dart';

class CartPage extends StatelessWidget {
  final int pageId;
  String page;
   CartPage({Key? key, required this.pageId, required this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _noteController = TextEditingController();
  //  var location = Get.find<LocationController>().getUserAddress();

    return Scaffold(
    backgroundColor: Colors.white,

      body:Stack(
        children: [
          Positioned(
              top: 60,
              left: 20,
              right: 20,
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 6),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.mainColor,
                    ),
                    child: GestureDetector(
                      onTap: (){
                        if(page=="recommended"){
                          Get.toNamed(RouteHelper.getRecommendedFoodRoute(pageId, page));
                        }else if(page=='popular'){
                          Get.toNamed(RouteHelper.getPopularFoodRoute(pageId, page, RouteHelper.cartPage));
                        }else if(page=='cart-history'){
                          showCustomSnackBar("Product review is not available from cart history", isError: false,title: "Order more");
                        }else{
                          Get.offNamed(RouteHelper.getInitialRoute());
                        }
                      },
                      child: Center(
                          child: Icon(
                            Icons.arrow_back_ios,
                            size: 16,
                            color: Colors.white,
                          )),
                    ),
                  ),
                  SizedBox(width: 100,),
                  Container(
                    //padding: const EdgeInsets.only(left: 6),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.mainColor,
                    ),
                    child: GestureDetector(
                      onTap: (){
                        print("my page id is "+pageId.toString());

                          Get.offNamed(RouteHelper.getInitialRoute());

                      },
                      child: Center(
                          child: Icon(
                            Icons.home_outlined,
                            size: 20,
                            color: Colors.white,
                          )),
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.only(left: 0),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.mainColor,
                    ),
                    child: GetBuilder<CartController>(builder:(_){
                      return Stack(
                        children: [
                          Positioned(
                            child: Center(
                                child: Icon(
                                  Icons.shopping_cart_outlined,
                                  size: 16,
                                  color: Colors.white,
                                )),
                          ),
                          Get.find<CartController>().totalItems>=1?Positioned(
                            right: 3,
                            top:1,
                            child: Center(
                                child: Icon(
                                  Icons.circle,
                                  size: 20,
                                  color: Colors.white,
                                )),
                          ):Container(),
                          Get.find<CartController>().totalItems>=1?Positioned(
                            right: 7,
                            top:4,
                            child: Center(
                                child:  Text(
                                  Get.find<CartController>().totalItems.toString(),
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54
                                  ),
                                )
                            ),
                          ):Container()
                        ],
                      );
                    }),
                  )
                ],
              )),
          GetBuilder<CartController>(builder: (_){
            return  Get.find<CartController>().getCarts.length>0?Positioned(
                top: 100,
                left: 0,
                right: 0,
                //with bottom property 0, we can make it scrollable
                bottom: 0,
                child: Container(
                  color: Colors.white,
                  // height: 600,
                  //width: 300,
                  child:  GetBuilder<CartController>(builder: (cartController){
                    // print("here from cart "+cartController.getCarts[1].quantity.toString());
                    List<CartItem> _cartList = Get.find<CartController>().getCarts;
                    return  MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: ListView.builder(
                          itemCount: _cartList.length,
                          itemBuilder: (_, index){
                            return Container(
                              //color: Colors.red,
                              width: double.maxFinite,
                              height: 100,
                              margin:  EdgeInsets.all(Dimensions.padding10),
                              child: _cartList[index].quantity>0?
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                //this setting should come at the end to make sense. this is important for the cart + - button
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      var getPageIndex=Get.find<ProductController>().popularProductList.indexOf(_cartList[index].product);

                                      // page = "recommended";
                                      if(getPageIndex<0){
                                        getPageIndex=Get.find<PopularProduct>().popularProductList.indexOf(_cartList[index].product);
                                        // page="popular";
                                      }
                                      if(getPageIndex<0){
                                        showCustomSnackBar("Product review is not available from cart history", isError: false,title: "Order more");

                                      }else{
                                        if(page=="recommended"){
                                          Get.toNamed(RouteHelper.getRecommendedFoodRoute(getPageIndex, page));
                                        }else if(page=="popular"){
                                          Get.toNamed(RouteHelper.getPopularFoodRoute(getPageIndex, page, RouteHelper.cartPage));
                                        }else if(page=='cart-history'){
                                          showCustomSnackBar("Product review is not available from cart history", isError: false,title: "Order more");
                                        }else{
                                          Get.toNamed(RouteHelper.getInitialRoute());
                                        }
                                      }
                                    },
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                  AppConstants.UPLOADS_URL+_cartList[index].img
                                              )
                                          ),
                                          borderRadius: BorderRadius.circular(Dimensions.padding20),
                                          color: Colors.white
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: Dimensions.padding10,),
                                  Expanded(
                                    child: Container(
                                      //since column needs height, without this container height this column would take min
                                      //size. Previously this column inside the Row, it didn't know the height. Now because of
                                      //container height, column would occupy the maximun height
                                      height: 100,
                                      //width:260,
                                      child: Column(
                                        //mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        //spacebetween pushes to the end of the upper boundary
                                        //spaceAround has the middle upper boundary
                                        //spaceEvenly has the lowest upper boundary
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(

                                            cartController.getCarts[index].title,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(

                                              color:Colors.black54,
                                              fontSize:20,
                                              fontWeight: FontWeight.w600,

                                            ),
                                          ),
                                          /* BigText(text: cartController.getCarts[index].title,
                                                  color: AppColors.titleColor),*/
                                          TextWidget(text:"Spicy", color:AppColors.textColor,),
                                          Row(
                                            children: [
                                              BigText(text: "\$ "+cartController.getCarts[index].price.toString(), color: Colors.redAccent),
                                              SizedBox(width: Dimensions.padding10,),
                                              Expanded(child: Container()),
                                              Align(
                                                alignment: Alignment.bottomRight,
                                                child: Container(
                                                  padding:  EdgeInsets.all(Dimensions.padding5),
                                                  child: Row(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: (){

                                                          var quantity = -1;
                                                          Get.find<CartController>().addItem(_cartList[index].product, quantity);

                                                        },
                                                        child: Icon(Icons.remove, color: AppColors.signColor),
                                                      ),
                                                      SizedBox(width: Dimensions.padding5),
                                                      GetBuilder<ProductController>(builder: (_){
                                                        return BigText(text: _cartList[index].quantity.toString(), color: AppColors.mainBlackColor);
                                                      },),
                                                      SizedBox(width: Dimensions.padding5),
                                                      GestureDetector(
                                                        onTap: (){
                                                          var quantity = 1;
                                                          Get.find<CartController>().addItem(_cartList[index].product, quantity);

                                                        },
                                                        child: Icon(Icons.add, color: AppColors.signColor),
                                                      ),
                                                    ],
                                                  ),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(Dimensions.padding20),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            offset: Offset(0, 0),
                                                            blurRadius: 10,
                                                            //spreadRadius: 3,
                                                            color: AppColors.titleColor.withOpacity(0.05))
                                                      ]),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  )

                                ],
                              )
                                  :Container(),
                            );
                          }),
                    );
                  }),
                )):NoDataScreen(text: "Your cart is empty!");
          })
        ],
      ),
      bottomNavigationBar: GetBuilder<OrderController>(builder: (orderController){
          return !orderController.isLoading? Container(
            width: double.maxFinite,
            margin: EdgeInsets.only(
                left: Dimensions.detailFoodImgPad,
                right: Dimensions.detailFoodImgPad),
            height: Dimensions.buttonButtonCon,
            padding:
            EdgeInsets.only(top: Dimensions.padding20, bottom: Dimensions.padding30, left: 10, right: 10),
            child: GetBuilder<CartController>(builder: (_){
              return Get.find<CartController>().getCarts.length>0?Row(
                children: [
                  Container(
                    padding:  EdgeInsets.all(Dimensions.padding20),
                    child: Row(
                      children: [
                        SizedBox(width: Dimensions.padding10),
                        GetBuilder<CartController>(builder: (_){
                          return BigText(text: "\$ "+ Get.find<CartController>().totalAmount.toString(), color: AppColors.mainBlackColor);
                        },),
                        SizedBox(width: Dimensions.padding10),
                      ],
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(Dimensions.padding20),
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(0, 0),
                              blurRadius: 10,
                              //spreadRadius: 3,
                              color: AppColors.titleColor.withOpacity(0.05))
                        ]),
                  ),
                  Expanded(child: Container()),

                  GestureDetector(
                      onTap: (){
                        if(!Get.find<AuthController>().isLoggedIn()){
                          Get.toNamed(RouteHelper.getSignInRoute());
                        }else{
                          if(Get.find<LocationController>().addressList.isEmpty){
                            Get.toNamed(RouteHelper.getAddAddressRoute());
                          }else{
                            var location = Get.find<LocationController>().getUserAddress();
                            orderController.placeOrder(PlaceOrderBody(
                              cart: Get.find<CartController>().getCarts,
                              /*
                          next line 100 is a fake data
                           */
                              orderAmount: 100.0,
                              orderNote: "Note about food",
                              address: location.address,
                              latitude: location.latitude,
                              longitude: location.longitude,
                              contactPersonName: location.contactPersonName ?? Get.find<UserController>().userInfoModel.fName,
                              contactPersonNumber: location.contactPersonNumber ?? Get.find<UserController>().userInfoModel.phone,
                              scheduleAt: '', distance: 10,
                            ), _callback);

                            Get.find<CartController>().clear();
                            Get.find<CartController>().removeCartSharedPreference();
                            Get.find<CartController>().addToHistory();
                          }
                        }
                      },
                      child: Container(
                        child: BigText(
                          size: 20,
                          text: "Check out",
                          color: Colors.white,
                        ),
                        padding:  EdgeInsets.all(Dimensions.padding20),
                        decoration: BoxDecoration(
                            color: AppColors.mainColor,
                            borderRadius: BorderRadius.circular(Dimensions.padding20),
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(0, 5),
                                  blurRadius: 10,
                                  //spreadRadius: 3,
                                  color: AppColors.mainColor.withOpacity(0.3))
                            ]),
                      )
                  )

                ],
              ):Container();
            }),
            decoration: BoxDecoration(
                color: AppColors.buttonBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Dimensions.padding20),
                  topRight: Radius.circular(Dimensions.padding20),
                )),
          ):CustomLoader();
      })
    );
  }
  void _callback(bool isSuccess, String message, String orderID) async {
    if(isSuccess) {

      Get.find<CartController>().clearCartList();

      Get.find<OrderController>().stopLoader();
      if( Get.find<OrderController>().paymentMethodIndex == 1) {
        //Get.offNamed(RouteHelper.getOrderSuccessRoute(orderID, 'success'));
        //Get.offNamed(RouteHelper.getInitialRoute());
        Get.offNamed(RouteHelper.getPaymentRoute(orderID, Get.find<UserController>().userInfoModel.id));

      }else {
        if(GetPlatform.isWeb) {
          Get.back();
         // String hostname = html.window.location.hostname;
         // String protocol = html.window.location.protocol;
         // String selectedUrl = '${AppConstants.BASE_URL}/payment-mobile?order_id=$orderID&&customer_id=${Get.find<UserController>()
           //   .userInfoModel.id}&&callback=$protocol//$hostname${RouteHelper.orderSuccess}?id=$orderID&status=';
          //html.window.open(selectedUrl,"_self");
        } else{
          print("working fine");
          Get.offNamed(RouteHelper.getPaymentRoute(orderID, Get.find<UserController>().userInfoModel.id));
        }
      }
    }else {
      print(message);
      showCustomSnackBar(message);
    }
  }
}
