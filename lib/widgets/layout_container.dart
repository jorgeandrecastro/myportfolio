import 'package:flutter/material.dart';

class LayoutContainer extends StatelessWidget {
  final Widget child;
  const LayoutContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: child,
        ),
      ),
    );
  }
}
