import 'package:flutter/material.dart';
import 'package:warsha_commerce/views/shopping_cart/cart_items.dart';
import 'package:warsha_commerce/views/shopping_cart/order_summary.dart';

import 'timeline_stepper.dart';

class ShoppingCart extends StatelessWidget {
  const ShoppingCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              bool isMobile = constraints.maxWidth < 900;

              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 40.0,
                    horizontal: isMobile ? 20.0 : 80.0,
                  ),
                  child: Column(
                    children: [
                      const TimelineStepper(),
                      const SizedBox(height: 50),

                      if (isMobile)
                        Column(
                          children: [
                            RightCartColumn(),
                            const SizedBox(height: 40),
                            const OrderSummary(),
                          ],
                        )
                      else
                      // Desktop: Row (Side by Side)
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
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}