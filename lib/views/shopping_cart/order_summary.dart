import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warsha_commerce/utils/default_button.dart';
import 'package:warsha_commerce/view_models/cart_v_m.dart';
import 'package:warsha_commerce/views/shopping_cart/container_style.dart';

class OrderSummary extends StatelessWidget {
  const OrderSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return StyledContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "ملخص الطلب",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),

          // Coupon Row
          Container(
            padding: const EdgeInsetsDirectional.fromSTEB(15, 5, 5, 5),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary.withAlpha(10),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                Icon(Icons.confirmation_number_outlined, size: 30),
                const SizedBox(width: 10),
                const Expanded(
                  // Expanded added to prevent overflow
                  child: Text(
                    "كود الخصم",
                    style: TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiary,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    "تطبيق",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onTertiary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),
          _summaryRow("المجموع الفرعي", context, "${Provider.of<CartVM>(context).totalAmount} EGP"),
          const SizedBox(height: 15),
          _summaryRow("خصم (-5%)", context, "${Provider.of<CartVM>(context).totalAmount - Provider.of<CartVM>(context).totalAmount * 0.95}", isRed: true),
          const SizedBox(height: 15),
          _summaryRow("رسوم التوصيل", context, "15 EGP"),
          const SizedBox(height: 30),
          Divider(),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:  [
              const Text(
                "الإجمالي",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                "${Provider.of<CartVM>(context).totalAmount - Provider.of<CartVM>(context).totalAmount * 0.05} EGP",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
              ),
            ],
          ),
          const SizedBox(height: 30),

          DefaultButton(
            onTap: () {
              Provider.of<CartVM>(
                context,
                listen: false,
              ).placeOrder(customerId: 4084);
            },
            title: "الذهاب للدفع",
            margin: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(
    String label,
    BuildContext context,
    String value, {
    bool isRed = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: isRed ? Colors.red : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
