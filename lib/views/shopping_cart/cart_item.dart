import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:warsha_commerce/services/base_url.dart';
import 'package:warsha_commerce/utils/const_values.dart';
import 'package:warsha_commerce/utils/image_helper.dart';
import 'package:warsha_commerce/views/shopping_cart/cart_items.dart';

class CartItemRow extends StatelessWidget {

  const CartItemRow({super.key, required this.data, required this.increment, required this.decrement, required this.removeItem});

  final CartItemData data;
  final void Function() increment;
  final void Function() decrement;
  final void Function() removeItem;

  @override
  Widget build(BuildContext context) {
    // Check if screen is very small to adjust layout inside row
    bool isSmallScreen = MediaQuery.of(context).size.width < 500;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image Placeholder
        Container(
          width: isSmallScreen ? 80 : 110, // Smaller image on mobile
          height: isSmallScreen ? 80 : 110,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiary.withAlpha(10),
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.tertiary.withAlpha(20),
            ),
          ),
          alignment: Alignment.center,
          child: Container(
            padding: const EdgeInsets.all(0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceTint,
              borderRadius: Constants.BORDER_RADIUS_20,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.network(
                "${Baseurl.baseURLImages}${ImageHelper.extractFileId(data.image)}",
                width: isSmallScreen ? 70 : 100, // Smaller image on mobile
                height: isSmallScreen ? 70 : 100,
                fit: BoxFit.cover,
                // Show a loading spinner while the image is loading
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return SizedBox(
                    width: 50,
                    height: 50,
                    child: Center(
                      child: SpinKitChasingDots(
                        color: Theme.of(context).colorScheme.tertiary,
                        size: 20,
                      ),
                    ),
                  );
                },
                // Show a fallback if the image fails to load
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Iconsax.shopping_bag,
                    size: 40,
                  );
                },
              ),
            ),
          ),

        ),


        SizedBox(width: isSmallScreen ? 15 : 25),

        // Item Details (Wrapped in Expanded to avoid overflow)
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.name,
                style: TextStyle(
                    fontSize: isSmallScreen ? 16 : 18,
                    fontWeight: FontWeight.bold
                ),
                overflow: TextOverflow.ellipsis, // Safety for long names
              ),
              const SizedBox(height: 8),
              Text("الحجم: ${data.size}", style: TextStyle(fontSize: isSmallScreen ? 12 : 14)),
              Text("اللون: ${data.color}", style: TextStyle(fontSize: isSmallScreen ? 12 : 14)),
              const SizedBox(height: 20),
              Text(
                "${data.price} EGP",
                style: TextStyle(
                    fontSize: isSmallScreen ? 16 : 20,
                    fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
        ),

        // Actions (Trash & Counter)
        SizedBox(
          height: isSmallScreen ? 80 : 110,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: removeItem,
                  icon: Icon(Iconsax.trash_copy, color: Colors.red,
                  ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 4 : 8,
                  vertical: 0,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary.withAlpha(10),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: increment,
                        icon: Icon(Icons.add, size: isSmallScreen ? 16 : 18)),
                    SizedBox(width: isSmallScreen ? 10 : 20),
                    Text(
                      "${data.quantity}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: isSmallScreen ? 14 : 16,
                      ),
                    ),
                    SizedBox(width: isSmallScreen ? 10 : 20),
                    IconButton(
                        onPressed: decrement,
                        icon: Icon(Icons.remove, size: isSmallScreen ? 16 : 18)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}