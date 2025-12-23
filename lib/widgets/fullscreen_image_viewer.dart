//Vue plein écran avec zoom
//Boutons fermer/supprimer
//Confirmation de suppression
import 'package:flutter/material.dart';

class FullscreenImageViewer extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onDelete;

  const FullscreenImageViewer({
    super.key,
    required this.imageUrl,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Image avec zoom
          Center(
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: Image.network(imageUrl, fit: BoxFit.contain),
            ),
          ),

          // Bouton fermer (top right)
          Positioned(
            top: 40,
            right: 20,
            child: _CircleButton(
              icon: Icons.close_rounded,
              color: Colors.white.withOpacity(0.15),
              iconColor: Colors.white,
              onTap: () => Navigator.pop(context),
            ),
          ),

          // Bouton supprimer (top left)
          Positioned(
            top: 40,
            left: 20,
            child: _CircleButton(
              icon: Icons.delete_outline,
              color: Colors.red.withOpacity(0.9),
              iconColor: Colors.white,
              onTap: () => _confirmDelete(context),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Supprimer cette image ?"),
        content: const Text("Cette action est irréversible."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Fermer le dialog
              onDelete(); // Supprimer l'image
            },
            child: const Text(
              "Supprimer",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color iconColor;
  final VoidCallback onTap;

  const _CircleButton({
    required this.icon,
    required this.color,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
            ),
          ],
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: icon == Icons.close_rounded ? 28 : 24,
        ),
      ),
    );
  }
}
