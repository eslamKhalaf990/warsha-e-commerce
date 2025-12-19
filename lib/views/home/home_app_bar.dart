import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warsha_commerce/view_models/cart_v_m.dart';
import 'package:warsha_commerce/view_models/product_v_m.dart';

class WarshaAppBar extends StatelessWidget {
  final bool isMobile;
  final bool isDesktop;

  const WarshaAppBar({
    super.key,
    required this.isMobile,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      // Increase height to accommodate the larger search bar comfortably
      toolbarHeight: 80,
      titleSpacing: 0, // Remove default padding to control layout manually

      // --- PART 1: TOP ROW (Logo + Search + Icons) ---
      title: Padding(
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 16.0 : 40.0),
        child: Row(
          children: [
            // 1. Logo Section
            Image.asset(
              "assets/images/logo.jpg",
              height: 40, // Adjusted to match the sleek look
              fit: BoxFit.contain,
            ),

            const SizedBox(width: 40),

            // 2. Center Search Bar (Hidden on Mobile, Visible on Desktop)
            if (!isMobile)
              Expanded(
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 600), // Max width like screenshot
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50), // Pill shape
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          "Search for accessories...",
                          style: TextStyle(color: Colors.grey[500], fontSize: 14),
                        ),
                        const Spacer(),
                        Icon(Icons.mic_none, color: Colors.grey[600], size: 20),
                        const SizedBox(width: 12),
                        Icon(Icons.search, color: Colors.grey[600], size: 22),
                      ],
                    ),
                  ),
                ),
              )
            else
              const Spacer(), // Pushes icons to right on mobile

            // 3. Right Actions
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Search Icon (Mobile Only - since desktop has the bar)
                if (isMobile)
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.search, color: Colors.black87),
                  ),

                // Desktop Extra Icons (Search icon usually redundant if bar exists, but keeping per design)
                if (!isMobile)
                  IconButton(onPressed: () {}, icon: const Icon(Icons.search, color: Colors.black87)),

                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  icon: const Icon(Icons.person_outline, color: Colors.black87),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/shopping_cart');
                  },
                  icon: Badge(
                    label: Text(Provider.of<CartVM>(context, listen: true).itemCount.toString()),
                    backgroundColor: Colors.black,
                    child: Icon(Icons.shopping_bag_outlined, color: Colors.black87),
                  ),
                ),
                const SizedBox(width: 8),
                // Theme/Dark Mode Toggle
                Container(
                  height: 24, // Divider height
                  width: 1,
                  color: Colors.grey[300],
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.brightness_medium_outlined, color: Colors.black87),
                ),
              ],
            ),
          ],
        ),
      ),

      // --- PART 2: BOTTOM NAV ROW (Categories) ---
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(isMobile ? 1 : 60), // Hide nav row on mobile (use drawer instead)
        child: Column(
          children: [
            if (!isMobile)
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Consumer<ProductVM>(
                  builder: (context, value, child) => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      value.allCategories?.length ?? 0,
                          (index) => _NavCategory(
                        title: value.allCategories![index].name,
                        isRed: index == 0,
                      ),
                    ),
                  ),
                ),
              ),
            // The subtle divider line at the very bottom
            Container(color: Colors.grey[200], height: 1),
          ],
        ),
      ),
    );
  }
}


// --- HELPER WIDGET FOR NAV ITEMS ---
class _NavCategory extends StatelessWidget {
  final String title;
  final bool hasDropdown;
  final bool isRed;

  const _NavCategory({
    required this.title,
    this.hasDropdown = false,
    this.isRed = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      hoverColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isRed ? Colors.red[700] : Colors.black87,
              ),
            ),
            if (hasDropdown) ...[
              const SizedBox(width: 4),
              Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.black87)
            ]
          ],
        ),
      ),
    );
  }
}