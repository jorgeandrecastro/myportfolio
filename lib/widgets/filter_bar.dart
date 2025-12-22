import 'package:flutter/material.dart';

class FilterBar extends StatelessWidget {
  final List<String> categories;
  final String selectedFilter;
  final Function(String) onSelect;

  const FilterBar({
    super.key,
    required this.categories,
    required this.selectedFilter,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = selectedFilter == cat;

          return GestureDetector(
            onTap: () => onSelect(cat),
            child: Container(
              margin: const EdgeInsets.only(right: 25),
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected ? Colors.black : Colors.transparent,
                    width: 1.5,
                  ),
                ),
              ),
              child: Text(
                cat.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 2.0, // Espacement luxe
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w300,
                  color: isSelected ? Colors.black : Colors.grey[400],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
