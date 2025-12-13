import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:warsha_commerce/views/shopping_cart/cart_items.dart';
import 'package:warsha_commerce/views/shopping_cart/order_summary.dart';
import 'package:warsha_commerce/views/sign_in/sign_in.dart';

class TimelineController extends ChangeNotifier {
  int page = 0;

  final List<Widget> desktopSteps = [
    DeliveryDetailsPage(),
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            flex: 10,
            child: RightCartColumn()
        ),
        const SizedBox(width: 40),
        const Expanded(
            flex: 6,
            child: OrderSummary()
        ),
      ],
    ),
  ];

  final List<Widget> mobileSteps = [
    DeliveryDetailsPage(),
    Column(
      children: [
        RightCartColumn(),
        const SizedBox(height: 40),
        const OrderSummary(),
      ],
    )
  ];

  void nextPage() {
    if (page < desktopSteps.length - 1) {
      page++;
      notifyListeners();
    }
  }

  void previousPage() {
    if (page > 0) {
      page--;
      notifyListeners();
    }
  }

  void changePage(int index) {
    print("page changed to $index");
    page = index;
    notifyListeners();
  }
}
