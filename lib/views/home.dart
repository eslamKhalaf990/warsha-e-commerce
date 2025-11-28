import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warsha_commerce/models/product_model.dart';
import 'package:warsha_commerce/services/base_url.dart';
import 'package:warsha_commerce/utils/image_helper.dart';
import 'package:warsha_commerce/view_models/product_v_m.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ProductVM>(
        builder: (context, vm, child) {
          // --- Loading State ---
          if (vm.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.black87,
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

class ProductCard extends StatefulWidget {
  final Product product;
  final bool isMobile;
  final double imageAspectRatio; // New parameter

  const ProductCard({
    super.key,
    required this.product,
    required this.isMobile,
    this.imageAspectRatio = 1.2, // Default if not passed
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> with AutomaticKeepAliveClientMixin{
  bool _isHovered = false;
  bool _isFavorited = false;

  @override
  Widget build(BuildContext context) {
    final formattedPrice = widget.product.sellingPrice.toStringAsFixed(2);
    final int stock = int.tryParse(widget.product.quantity) ?? 0;
    final bool isOutOfStock = stock <= 0;
    super.build(context);

    return MouseRegion(
      cursor: isOutOfStock ? SystemMouseCursors.basic : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: isOutOfStock ? null : () {},
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.identity()
            ..translate(0.0, _isHovered && !widget.isMobile ? -4.0 : 0.0),
          decoration: BoxDecoration(
            color: Colors.white,
            // Modern subtle border for structure
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(0), // Slight rounding looks more premium
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isHovered ? 0.08 : 0.0),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- 1. IMAGE SECTION (AspectRatio enforced) ---
              AspectRatio(
                aspectRatio: 1 / widget.imageAspectRatio, // Invert for AspectRatio widget
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(0)),
                      child: Opacity(
                        opacity: isOutOfStock ? 0.6 : 1.0,
                        child: CachedNetworkImage(
                          imageUrl: "${Baseurl.baseURLImages}${ImageHelper.extractFileId(widget.product.imageUrl)}",
                          fit: BoxFit.cover,
                          memCacheWidth: 400,
                          placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black87,
                            ),
                          ),
                          errorWidget: (context, url, error) => const Icon(Icons.broken_image, color: Colors.grey),
                        ),
                      ),
                    ),

                    // Badge
                    Positioned(
                      top: 8, left: 8,
                      child: isOutOfStock
                          ? _buildBadge("SOLD OUT", Colors.grey[800]!)
                          : _buildBadge("NEW", Colors.black),
                    ),

                    // Favorite Icon
                    Positioned(
                      top: 8, right: 8,
                      child: InkWell(
                        onTap: () => setState(() => _isFavorited = !_isFavorited),
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: Colors.white.withOpacity(0.9),
                          child: Icon(
                              _isFavorited ? Icons.favorite : Icons.favorite_border,
                              size: 16,
                              color: _isFavorited ? Colors.red : Colors.black87
                          ),
                        ),
                      ),
                    ),

                    // Desktop Hover Overlay
                    if (!widget.isMobile && !isOutOfStock)
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: _isHovered ? 1.0 : 0.0,
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter, end: Alignment.bottomCenter,
                                colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
                              )
                          ),
                          padding: const EdgeInsets.all(12),
                          child: SizedBox(
                            width: double.infinity,
                            height: 36,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                              ),
                              child: const Text("ADD", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // --- 2. TEXT DETAILS (Flexible logic) ---
              // We use Expanded here to fill the remaining space calculated by our grid formula
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Pushes price to bottom
                    children: [
                      // Top Part: Category & Name
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.product.categoryName.toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey[500]),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.product.name,
                            maxLines: 2, // Limit to 2 lines
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13, // Slightly smaller for better fit
                              fontWeight: FontWeight.w600,
                              height: 1.2,
                              color: isOutOfStock ? Colors.grey : Colors.black87,
                            ),
                          ),
                        ],
                      ),

                      // Bottom Part: Price & Action
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Flexible(
                            child: Text(
                              "EGP $formattedPrice",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: isOutOfStock ? Colors.grey : Colors.black,
                              ),
                            ),
                          ),
                          if (widget.isMobile && !isOutOfStock)
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                              child: const Icon(Icons.add, color: Colors.white, size: 16),
                            )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(0)),
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w900)),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

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
                  onPressed: () {},
                  icon: const Icon(Icons.person_outline, color: Colors.black87),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/shopping_cart');
                  },
                  icon: const Badge(
                    label: Text('2'),
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