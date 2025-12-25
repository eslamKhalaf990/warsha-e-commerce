import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warsha_commerce/utils/const_values.dart';
import 'package:warsha_commerce/view_models/order_v_m.dart';
import 'package:warsha_commerce/views/shopping_cart/container_style.dart';

class OrdersHistory extends StatelessWidget {
  const OrdersHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderVM>(
      builder: (context, orderVM, child) => Scaffold(
        appBar: AppBar(
          title: const Text("طلباتي السابقة", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: orderVM.isLoading ? const CircularProgressIndicator(
              color: Colors.black,
              strokeWidth: 2,
            ) : ListView.separated(
              padding: const EdgeInsets.all(15),
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) {
                return OrderHistoryCard(index: index);
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 20);
              },
            ),
          ),
        ),
      ),
    );
  }
}

class OrderHistoryCard extends StatelessWidget {
  final int index;
  const OrderHistoryCard({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return StyledContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "طلب رقم #1234$index",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              _buildStatusChip(context, index % 2 == 0 ? "مكتمل" : "قيد التوصيل"),
            ],
          ),
          const Divider(height: 30),

          _historyRow("التاريخ", "2025-12-$index"),
          const SizedBox(height: 10),
          _historyRow("إجمالي المبلغ", "550.0 EGP"),
          const SizedBox(height: 10),
          _historyRow("عدد المنتجات", "3 منتجات"),

          const SizedBox(height: 20),

          // Reusing the "Apply" button style for "Details"
          InkWell(
            onTap: () {
              // Navigate to order details
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary,
                  borderRadius: Constants.BORDER_RADIUS_5,
              ),
              child: Center(
                child: Text(
                  "عرض التفاصيل",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _historyRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildStatusChip(BuildContext context, String status) {
    bool isDone = status == "مكتمل";
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isDone ? Colors.green.withAlpha(30) : Colors.orange.withAlpha(30),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: isDone ? Colors.green : Colors.orange,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}