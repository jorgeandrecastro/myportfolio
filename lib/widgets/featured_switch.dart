//Switch VIP simple et réutilisable
import 'package:flutter/material.dart';

class FeaturedSwitch extends StatelessWidget {
  final bool isFeatured;
  final ValueChanged<bool> onChanged;

  const FeaturedSwitch({
    super.key,
    required this.isFeatured,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isFeatured ? Colors.black.withOpacity(0.02) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isFeatured ? Colors.black : Colors.black12,
          width: 1.5,
        ),
      ),
      child: SwitchListTile(
        title: const Text(
          "METTRE EN AVANT (HOME PAGE)",
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
        subtitle: const Text(
          "Le projet apparaîtra dans la section VIP de l'accueil.",
          style: TextStyle(fontSize: 10, color: Colors.grey),
        ),
        value: isFeatured,
        activeColor: Colors.black,
        contentPadding: EdgeInsets.zero,
        onChanged: onChanged,
      ),
    );
  }
}
