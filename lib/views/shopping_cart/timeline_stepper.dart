import 'package:flutter/material.dart';

class TimelineStepper extends StatelessWidget {
  const TimelineStepper({super.key});

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