import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warsha_commerce/view_models/cart_v_m.dart';
import 'cart_item.dart'; // Your UI Widget
import 'container_style.dart'; // Your UI Widget

class CartItemData {
  final String name;
  final String image;
  final String size;
  final String color;
  final int price;
  final int quantity;

  const CartItemData({
    required this.name,
    required this.image,
    required this.size,
    required this.color,
    required this.price,
    required this.quantity,
  });
}

class RightCartColumn extends StatelessWidget {
  const RightCartColumn({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartVM>(context);
    final cartItems = cart.items.values.toList();
    final productIds = cart.items.keys.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- Header (Select All & Delete) ---
        StyledContainer(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
            children: [
              // Fake Checkbox for visual consistency
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    width: 1,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
                child: const Icon(
                  Icons.check,
                  size: 16,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 15),
              const Text(
                "تحديد الكل",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),

              // Delete Action
              InkWell(
                onTap: () {
                  // UX: Confirm before deleting everything
                  cart.clear();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiary,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    "حذف المحدد",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onTertiary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 25),

        // --- Cart Items List (Dynamic) ---
        cartItems.isEmpty
            ? _buildEmptyState()
            : StyledContainer(
                child: ListView.separated(
                  shrinkWrap: true, // Vital when inside a Column
                  physics:
                      const NeverScrollableScrollPhysics(), // Let the parent scroll
                  itemCount: cartItems.length,
                  separatorBuilder: (ctx, i) => const Divider(height: 40),
                  itemBuilder: (ctx, i) {
                    final providerItem = cartItems[i];
                    final currentId = productIds[i];

                    // 2. Adapter: Convert Provider Model -> UI Model
                    // We map the data so your existing CartItemRow works without changes
                    final uiModel = CartItemData(
                      name: providerItem.title,
                      size: "M",
                      color: "Black",
                      price: providerItem.price.toInt(),
                      quantity: providerItem.quantity,
                      image: providerItem.imageUrl,
                    );

                    return CartItemRow(
                      data: uiModel,
                      increment: () {
                        cart.incrementItemQty(currentId);
                      },
                      decrement: () {
                        cart.decrementItemQty(currentId);
                      },
                      removeItem: () {
                        cart.removeItem(currentId);
                      },
                    );
                  },
                ),
              ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return StyledContainer(
      child: const Padding(
        padding: EdgeInsets.all(40.0),
        child: Center(child: Text("السلة فارغة")),
      ),
    );
  }
}
