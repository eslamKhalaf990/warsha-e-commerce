import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warsha_commerce/controllers/time_line.dart';
import 'package:warsha_commerce/views/shopping_cart/cart_items.dart';
import 'package:warsha_commerce/views/shopping_cart/order_summary.dart';
import 'package:warsha_commerce/views/sign_in/sign_in.dart';

import 'timeline_stepper.dart';

class ShoppingCart extends StatelessWidget {
  ShoppingCart({super.key});

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
                  child: Consumer<TimelineController>(
                    builder: (context, timeline, child) => Column(
                      children: [
                        const TimelineStepper(),
                        const SizedBox(height: 50),

                        if (isMobile)
                          timeline.mobileSteps[timeline.page]
                        else
                        // Desktop: Row (Side by Side)
                          timeline.desktopSteps[timeline.page]
                      ],
                    ),
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