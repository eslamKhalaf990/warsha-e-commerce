import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class ShoppingCart extends StatelessWidget {
  const ShoppingCart({super.key});

  // Arabic Data
  final List<_CartItemData> items = const [
    _CartItemData(
      name: "خاتم",
      size: "صغير",
      color: "أبيض",
      price: 145,
      quantity: 2,
    ),
    _CartItemData(
      name: "انسيال",
      size: "متوسط",
      color: "أحمر",
      price: 180,
      quantity: 4,
    ),
    _CartItemData(
      name: "سلسله",
      size: "كبير",
      color: "أزرق",
      price: 240,
      quantity: 8,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Force RTL for Arabic
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Breakpoint: If width is less than 900, treat as Mobile/Vertical Tablet
              bool isMobile = constraints.maxWidth < 900;

              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    // Responsive padding: smaller on mobile, larger on desktop
                    vertical: 40.0,
                    horizontal: isMobile ? 20.0 : 80.0,
                  ),
                  child: Column(
                    children: [
                      const _PageTitleAndStepper(),
                      const SizedBox(height: 50),

                      // RESPONSIVE SWITCHER
                      if (isMobile)
                      // Mobile: Column (Stacked)
                        Column(
                          children: [
                            _RightCartColumn(items: items),
                            const SizedBox(height: 40),
                            const _RightOrderSummary(),
                          ],
                        )
                      else
                      // Desktop: Row (Side by Side)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                flex: 10,
                                child: _RightCartColumn(items: items)
                            ),
                            const SizedBox(width: 40),
                            const Expanded(
                                flex: 6,
                                child: _RightOrderSummary()
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

// ==================== HELPER CLASSES & WIDGETS ====================

class _CartItemData {
  final String name;
  final String size;
  final String color;
  final int price;
  final int quantity;

  const _CartItemData({
    required this.name,
    required this.size,
    required this.color,
    required this.price,
    required this.quantity,
  });
}

// --- REUSABLE DESIGN COMPONENT (Your Custom Border Style) ---
class _StyledContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const _StyledContainer({
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // 1. The Space between border and inner box
      padding: const EdgeInsets.all(4.0),

      // 2. The Outer Border & Shadow
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          width: 1,
          color: Theme.of(context).colorScheme.primary,
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            spreadRadius: 1,
            color: Theme.of(context).colorScheme.onSurface.withAlpha(20),
          ),
        ],
      ),

      // 3. The Inner White Box
      child: Container(
        padding: padding ?? const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        child: child,
      ),
    );
  }
}

// --- 1. Page Title and Stepper ---
class _PageTitleAndStepper extends StatelessWidget {
  const _PageTitleAndStepper();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "سلة المشتريات",
          style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 40),
        // Changed SizedBox(width: 600) to Constraints to prevent overflow on mobile
        Container(
          constraints: const BoxConstraints(maxWidth: 600),
          width: double.infinity,
          child: Row(
            children: [
              _stepWidget("1", "السلة", context, isActive: true),
              _stepDivider(context),
              _stepWidget("2", "الدفع", context),
              _stepDivider(context),
              _stepWidget("3", "اكتمل", context), // Shortened text for mobile
            ],
          ),
        ),
      ],
    );
  }

  Widget _stepWidget(
      String number,
      String text,
      BuildContext context, {
        bool isActive = false,
      }) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive
                ? Theme.of(context).colorScheme.tertiary
                : Theme.of(context).colorScheme.primary,
          ),
          alignment: Alignment.center,
          child: Text(
            number,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isActive
                  ? Theme.of(context).colorScheme.onTertiary
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Flexible text to prevent overflow
        Text(
          text,
          style: TextStyle(
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _stepDivider(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Divider(thickness: 2),
      ),
    );
  }
}

// --- 2. Left Column: Cart Items Area ---
class _RightCartColumn extends StatelessWidget {
  final List<_CartItemData> items;
  const _RightCartColumn({required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header (Select All) - Using the reusable _StyledContainer
        _StyledContainer(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
            children: [
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
              ),
              const SizedBox(width: 15),
              const Text(
                "تحديد الكل",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                child: Text(
                  "حذف المحدد",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onTertiary,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 25),

        // Cart Items List - Using the reusable _StyledContainer
        _StyledContainer(
          child: Column(
            children: [
              _CartItemRow(data: items[0]),
              Divider(height: 40),
              _CartItemRow(data: items[1]),
              Divider(height: 40),
              _CartItemRow(data: items[2]),
            ],
          ),
        ),
      ],
    );
  }
}

// --- Individual Cart Item Row Widget ---
class _CartItemRow extends StatelessWidget {
  final _CartItemData data;
  const _CartItemRow({required this.data});

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
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.tertiary.withAlpha(20),
            ),
          ),
          alignment: Alignment.center,
          child: Icon(Icons.propane_tank_outlined, size: isSmallScreen ? 30 : 50),
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
              Icon(Iconsax.trash_copy, color: Colors.red),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 8 : 15,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary.withAlpha(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, size: isSmallScreen ? 16 : 18),
                    SizedBox(width: isSmallScreen ? 10 : 20),
                    Text(
                      "${data.quantity}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: isSmallScreen ? 14 : 16,
                      ),
                    ),
                    SizedBox(width: isSmallScreen ? 10 : 20),
                    Icon(Icons.remove, size: isSmallScreen ? 16 : 18),
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

// --- 3. Right Column: Order Summary Area ---
class _RightOrderSummary extends StatelessWidget {
  const _RightOrderSummary();

  @override
  Widget build(BuildContext context) {
    // Using the reusable _StyledContainer
    return _StyledContainer(
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
            ),
            child: Row(
              children: [
                Icon(Icons.confirmation_number_outlined, size: 30),
                const SizedBox(width: 10),
                const Expanded( // Expanded added to prevent overflow
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
          _summaryRow("المجموع الفرعي", context, "565 EGP"),
          const SizedBox(height: 15),
          _summaryRow("خصم (-20%)", context, " - 113 EGP", isRed: true),
          const SizedBox(height: 15),
          _summaryRow("رسوم التوصيل", context, "15 EGP"),
          const SizedBox(height: 30),
          Divider(),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "الإجمالي",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                "467 EGP",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
              ),
            ],
          ),
          const SizedBox(height: 30),

          // Checkout Button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary,
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "الذهاب للدفع",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onTertiary,
                  ),
                ),
                SizedBox(width: 10),
                Icon(
                  Icons.arrow_forward,
                  size: 20,
                  color: Theme.of(context).colorScheme.onTertiary,
                ),
              ],
            ),
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