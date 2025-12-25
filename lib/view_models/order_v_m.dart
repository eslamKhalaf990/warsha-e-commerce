import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:warsha_commerce/models/orderModel.dart';
import 'package:warsha_commerce/services/orders_service.dart';
import 'package:warsha_commerce/view_models/user_v_m.dart';

class OrderVM extends ChangeNotifier {
  final OrdersService _orderService;
  final UserViewModel _userViewModel;


  bool isLoading = false;
  bool isLogin = true;

  OrderVM(this._orderService, this._userViewModel){
    getCustomerOrder();
  }

  Future<List<OrderModel>> getCustomerOrder() async {
    List<OrderModel> ordersList = [];
    try {
      isLoading = true;
      final response = await _orderService.getAllOrders(_userViewModel.token);
      if (response.statusCode == 200) {
        final orders = jsonDecode(response.body);
        final List<dynamic> data = orders;
        ordersList = data.map((item) => OrderModel.fromJson(item)).toList();
      } else {
        debugPrint("Failed to fetch ordersList: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching ordersList: $e");
    } finally {

      isLoading = false;
      notifyListeners();
    }
    return ordersList;
  }



  void toggleLogin(bool state) {
    isLogin = state;
    notifyListeners();
  }
}
