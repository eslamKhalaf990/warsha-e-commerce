import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warsha_commerce/view_models/product_v_m.dart';
import 'package:warsha_commerce/views/home/poduct_card.dart';

import 'home_app_bar.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ProductVM>(
        builder: (context, vm, child) {
          // --- Loading State ---
          if (vm.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            );
          }

          // --- Empty State ---
          if (vm.allProducts == null || vm.allProducts!.isEmpty) {
            return _buildEmptyState();
          }

          // --- Main Content ---
          // Inside Home widget build method...

          return LayoutBuilder(
            builder: (context, constraints) {
              final double width = constraints.maxWidth;

              // --- 1. Breakpoints & Column Logic ---
              int crossAxisCount;
              double horizontalPadding;

              if (width < 450) {
                crossAxisCount = 2;
                horizontalPadding = 16;
              } else if (width < 900) {
                crossAxisCount = 3;
                horizontalPadding = 32;
              } else if (width < 1400) {
                crossAxisCount = 4;
                horizontalPadding = 64;
              } else {
                crossAxisCount = 5;
                horizontalPadding = (width - 1400) / 2; // Center content on huge screens
              }

              // --- 2. The "Brilliant" Aspect Ratio Formula ---
              // We calculate exactly how wide one card is in pixels
              double cardWidth = (width - (horizontalPadding * 2) - ((crossAxisCount - 1) * 20)) / crossAxisCount;

              // We define the expected fixed height of content (Text, Price, Buttons)
              // E.g., ~130px for title, category, price, and padding.
              const double fixedContentHeight = 145.0;

              // We decide the Image Aspect Ratio (e.g., images are 1:1 or 3:4)
              // If your product images are square, use 1.0. If portrait, use 1.2 or 1.3.
              const double imageAspectRatio = 1.2; // Image height = width * 1.2

              double cardHeight = (cardWidth * imageAspectRatio) + fixedContentHeight;

              // Final Grid Aspect Ratio
              double childAspectRatio = cardWidth / cardHeight;

              return CustomScrollView(
                physics: const BouncingScrollPhysics(), // Better feel on mobile
                slivers: [
                  WarshaAppBar(isDesktop: width >= 1100, isMobile: width < 600),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: 24,
                    ),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: childAspectRatio, // <--- DYNAMIC!
                        crossAxisSpacing: 20, // Horizontal space between cards
                        mainAxisSpacing: 24,  // Vertical space between cards
                      ),
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          return ProductCard(
                            product: vm.allProducts![index],
                            isMobile: width < 600,
                            imageAspectRatio: imageAspectRatio,
                          );
                        },
                        childCount: vm.allProducts!.length,
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 50)),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.checkroom_outlined, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            "No products available",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
