
import 'package:get/get.dart';
import 'package:shopping_app/models/order_model.dart';
import 'package:shopping_app/models/place_order.dart';
import 'package:shopping_app/models/response_model.dart';

import 'order_repo.dart';

class OrderController extends GetxController implements GetxService {
  final OrderRepo orderRepo;
  OrderController({required this.orderRepo});

  late List<OrderModel> _runningOrderList;
  late List<OrderModel> _historyOrderList;
  int _paymentMethodIndex = 0;
  late OrderModel _trackModel;
  late ResponseModel _responseModel;
  bool _isLoading = false;
  bool _showCancelled = false;
  String _orderType = 'delivery';

   double? _distance;

  List<OrderModel> get runningOrderList => _runningOrderList;
  List<OrderModel> get historyOrderList => _historyOrderList;
  int get paymentMethodIndex => _paymentMethodIndex;
  OrderModel get trackModel => _trackModel;
  ResponseModel get responseModel => _responseModel;
  bool get isLoading => _isLoading;
  bool get showCancelled => _showCancelled;
  String get orderType => _orderType;

  double get distance => _distance??0.0;

  Future<void> getOrderList() async {
    print("before the method getOrderList");
    _isLoading=true;
    Response response = await orderRepo.getOrderList();
    if (response.statusCode == 200) {
      print("found order list");
      _runningOrderList = [];
      _historyOrderList = [];
      response.body.forEach((order) {
        OrderModel orderModel = OrderModel.fromJson(order);
        if(orderModel.orderStatus == 'pending' || orderModel.orderStatus == 'accepted' || orderModel.orderStatus == 'confirmed'
            || orderModel.orderStatus == 'processing' || orderModel.orderStatus == 'handover' || orderModel.orderStatus == 'picked_up') {
          _runningOrderList.add(orderModel);
          print("I am adding to list");
        }else {
          _historyOrderList.add(orderModel);
          print("I did not get added to list");
        }
      });
    }else{
      _runningOrderList = [];
      _historyOrderList = [];
    }
    _isLoading=false;
    update();
  }


  void setPaymentMethod(int index) {
    _paymentMethodIndex = index;
    update();
  }
/*
  Future<ResponseModel> trackOrder(String orderID, OrderModel orderModel, bool fromTracking) async {
    _trackModel?? null;
    _responseModel??  null;

    _showCancelled = false;
    if(orderModel == null) {
      _isLoading = true;
      Response response = await orderRepo.trackOrder(orderID);
      if (response.statusCode == 200) {
        _trackModel = OrderModel.fromJson(response.body);
        _responseModel = ResponseModel(true, response.body.toString());
      } else {
        _responseModel = ResponseModel(false, response.statusText!);
      }
      _isLoading = false;
      update();
    }else {
      _trackModel = orderModel;
      _responseModel = ResponseModel(true, 'Successful');
    }
    return _responseModel;
  }*/

  Future<void> placeOrder(PlaceOrderBody placeOrderBody, Function callback) async {
    _isLoading = true;
    update();
   // print(placeOrderBody.toJson());
    print("repo sending through");
    Response response = await orderRepo.placeOrder(placeOrderBody);
    print("repo went through");
    _isLoading = false;
    if (response.statusCode == 200) {
      String message = response.body['message'];
      String orderID = response.body['order_id'].toString();
      callback(true, message, orderID);
      print('-------- Order placed successfully $orderID ----------');
    } else {
      callback(false, response.statusText, '-1');
    }
    update();
  }

  void stopLoader() {
    _isLoading = false;
    update();
  }

  void clearPrevData() {
    _paymentMethodIndex = 0;

    _distance = null;
  }

  void cancelOrder(int orderID) async {
    _isLoading = true;
    update();
    Response response = await orderRepo.cancelOrder(orderID.toString());
    _isLoading = false;
    Get.back();
    if (response.statusCode == 200) {
     late OrderModel orderModel;
      for(OrderModel order in _runningOrderList) {
        if(order.id == orderID) {
          orderModel = order;
          break;
        }
      }
      _runningOrderList.remove(orderModel);
      _showCancelled = true;
      //showCustomSnackBar(response.body['message'], isError: false);
      Get.snackbar("message", "Error");
    } else {
      print(response.statusText);
    }
    update();
  }

  void setOrderType(String type, {bool notify = true}) {
    _orderType = type;
    if(notify) {
      update();
    }
  }









}