import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:warsha_commerce/utils/const_values.dart';
import 'package:warsha_commerce/utils/default_button.dart';
import 'package:warsha_commerce/view_models/cart_v_m.dart';
import 'package:warsha_commerce/views/shopping_cart/container_style.dart';

class OrderCompleted extends StatelessWidget {
  final String orderNumber;
  final String totalAmount;
  final String paymentMethod;

  const OrderCompleted({
    super.key,
    required this.orderNumber,
    required this.totalAmount,
    this.paymentMethod = 'cash',
  });

  @override
  Widget build(BuildContext context) {
    final cartVM = Provider.of<CartVM>(context);

    return SingleChildScrollView(
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),

          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [

                // Success Animation
                AnimatedSuccessIcon(),

                const SizedBox(height: 30),

                // Success Message
                const Text(
                  "تم تأكيد طلبك بنجاح!",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 15),

                Text(
                  paymentMethod == 'cash'
                      ? "سيتم توصيل طلبك قريباً. الدفع عند الاستلام"
                      : "تم الدفع بنجاح. سيتم توصيل طلبك قريباً",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                // Order Details Card
                StyledContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "تفاصيل الطلب",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      _buildDetailRow(
                        context,
                        icon: Icons.receipt_long_outlined,
                        label: "رقم الطلب",
                        value: "#${cartVM.orderResponse?.orderId ?? 0000}",
                      ),

                      const SizedBox(height: 15),
                      const Divider(),
                      const SizedBox(height: 15),

                      _buildDetailRow(
                        context,
                        icon: Icons.calendar_today_outlined,
                        label: "تاريخ الطلب",
                        value: _getCurrentDate(),
                      ),

                      const SizedBox(height: 15),
                      const Divider(),
                      const SizedBox(height: 15),

                      _buildDetailRow(
                        context,
                        icon: paymentMethod == 'cash'
                            ? Icons.money
                            : Icons.credit_card,
                        label: "طريقة الدفع",
                        value: cartVM.orderResponse?.paymentMethod == null
                            ? "الدفع عند الاستلام"
                            : "بطاقة ائتمان",
                      ),

                      const SizedBox(height: 15),
                      const Divider(),
                      const SizedBox(height: 15),

                      _buildDetailRow(
                        context,
                        icon: Icons.payments_outlined,
                        label: "المبلغ الإجمالي",
                        value: "${cartVM.orderResponse?.totalPrice} EGP",
                        valueColor: Theme.of(context).colorScheme.tertiary,
                        valueBold: true,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Tracking Information
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiary.withAlpha(10),
                    borderRadius: Constants.BORDER_RADIUS_5,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.tertiary.withAlpha(50),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.tertiary,
                          borderRadius: Constants.BORDER_RADIUS_5,
                        ),
                        child: Icon(
                          Icons.local_shipping_outlined,
                          color: Theme.of(context).colorScheme.onTertiary,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "تتبع طلبك",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "يمكنك متابعة حالة طلبك من صفحة الطلبات",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Action Buttons
                DefaultButton(
                  onTap: () {
                    // Navigate to orders page
                    Navigator.pushNamed(context, '/orders_history');
                  },
                  title: "عرض طلباتي",
                  margin: EdgeInsets.zero,
                ),

                const SizedBox(height: 15),

                OutlinedButton(
                  onPressed: () {
                    // Navigate to home page
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/home',
                          (route) => false,
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 55),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.tertiary,
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: Constants.BORDER_RADIUS_5,
                    ),
                  ),
                  child: Text(
                    "العودة للرئيسية",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessIcon(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.tertiary.withAlpha(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.tertiary,
          width: 2,
        ),
      ),
      child: Icon(
        Iconsax.tick_circle_copy,
        color: Theme.of(context).colorScheme.tertiary,
        size: 80,
      ),
    );
  }

  Widget _buildDetailRow(
      BuildContext context, {
        required IconData icon,
        required String label,
        required String value,
        Color? valueColor,
        bool valueBold = false,
      }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiary.withAlpha(20),
            borderRadius: Constants.BORDER_RADIUS_5,
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.tertiary,
            size: 24,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: valueBold ? FontWeight.bold : FontWeight.w600,
                  color: valueColor ?? Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getCurrentDate() {
    final now = DateTime.now();
    final months = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر'
    ];
    return '${now.day} ${months[now.month - 1]} ${now.year}';
  }
}

class AnimatedSuccessIcon extends StatefulWidget {
  const AnimatedSuccessIcon({super.key});

  @override
  State<AnimatedSuccessIcon> createState() => _AnimatedSuccessIconState();
}

class _AnimatedSuccessIconState extends State<AnimatedSuccessIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _circleAnimation;
  late Animation<double> _iconAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500), // 1 second total
      reverseDuration: const Duration(milliseconds: 1500), // Half a second
    );

    // 1. The Circle Animation (Starts immediately, Bouncy)
    _circleAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.7, curve: Curves.elasticOut),
    );

    // 2. The Icon Animation (Starts after 0.2s, also Bouncy)
    _iconAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 1.0, curve: Curves.elasticOut),
    );

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Using ScaleTransition for high-performance animation
    return ScaleTransition(
      scale: _circleAnimation,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // Your original colors
          color: Theme.of(context).colorScheme.tertiary.withAlpha(20),
          border: Border.all(
            color: Theme.of(context).colorScheme.tertiary,
            width: 2,
          ),
        ),
        child: ScaleTransition(
          scale: _iconAnimation,
          child: Icon(
            Iconsax.tick_circle_copy, // Your icon
            color: Theme.of(context).colorScheme.tertiary,
            size: 80,
          ),
        ),
      ),
    );
  }
}