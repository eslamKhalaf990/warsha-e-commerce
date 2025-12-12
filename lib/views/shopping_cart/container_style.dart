import 'package:flutter/material.dart';

class StyledContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const StyledContainer({super.key,
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
        borderRadius: BorderRadius.circular(5),

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
