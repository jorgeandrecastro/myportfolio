import 'package:flutter/material.dart';

class GalleryImageGrid extends StatelessWidget {
  final List<String> imageUrls;
  final bool loading;
  final VoidCallback onAddImages;
  final Function(int) onRemoveImage;
  final Function(int) onViewImage;
  final Function(int, int) onReorder;

  const GalleryImageGrid({
    super.key,
    required this.imageUrls,
    required this.loading,
    required this.onAddImages,
    required this.onRemoveImage,
    required this.onViewImage,
    required this.onReorder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Grille des images avec flèches
        if (imageUrls.isNotEmpty) ...[
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1,
            ),
            itemCount: imageUrls.length,
            itemBuilder: (context, index) {
              return GalleryImageThumbnail(
                key: ValueKey(imageUrls[
                    index]), // ← SEUL CHANGEMENT pour corriger les flèches
                imageUrl: imageUrls[index],
                index: index,
                totalCount: imageUrls.length,
                onRemove: () => onRemoveImage(index),
                onView: () => onViewImage(index),
                onMoveLeft:
                    index > 0 ? () => onReorder(index, index - 1) : null,
                onMoveRight: index < imageUrls.length - 1
                    ? () => onReorder(index, index + 1)
                    : null,
              );
            },
          ),
          const SizedBox(height: 20),
        ],

        // Bouton d'ajout
        GalleryAddButton(
          loading: loading,
          isEmpty: imageUrls.isEmpty,
          onTap: onAddImages,
        ),
      ],
    );
  }
}

class GalleryImageThumbnail extends StatelessWidget {
  final String imageUrl;
  final int index;
  final int totalCount;
  final VoidCallback onRemove;
  final VoidCallback onView;
  final VoidCallback? onMoveLeft;
  final VoidCallback? onMoveRight;

  const GalleryImageThumbnail({
    super.key,
    required this.imageUrl,
    required this.index,
    required this.totalCount,
    required this.onRemove,
    required this.onView,
    this.onMoveLeft,
    this.onMoveRight,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onView,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0A0A0A),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              // Image
              Center(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: double.infinity,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),

              // Numéro d'ordre
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 0.5,
                    ),
                  ),
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // Bouton supprimer
              Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              // Flèches de navigation (en bas, centrées)
              Positioned(
                bottom: 6,
                left: 6,
                right: 6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Flèche gauche
                    if (onMoveLeft != null)
                      _ArrowButton(
                        icon: Icons.chevron_left_rounded,
                        onTap: onMoveLeft!,
                      ),

                    if (onMoveLeft != null && onMoveRight != null)
                      const SizedBox(width: 8),

                    // Flèche droite
                    if (onMoveRight != null)
                      _ArrowButton(
                        icon: Icons.chevron_right_rounded,
                        onTap: onMoveRight!,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ArrowButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ArrowButton({
    required this.icon,
    required this.onTap,
  });

  @override
  State<_ArrowButton> createState() => _ArrowButtonState();
}

class _ArrowButtonState extends State<_ArrowButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: _isPressed
              ? Colors.black.withOpacity(0.9)
              : Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.white.withOpacity(_isPressed ? 0.4 : 0.3),
            width: 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: _isPressed ? 3 : 6,
              offset: Offset(0, _isPressed ? 1 : 2),
            ),
          ],
        ),
        child: Icon(
          widget.icon,
          color: Colors.white,
          size: 18,
        ),
      ),
    );
  }
}

class GalleryAddButton extends StatelessWidget {
  final bool loading;
  final bool isEmpty;
  final VoidCallback onTap;

  const GalleryAddButton({
    super.key,
    required this.loading,
    required this.isEmpty,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loading ? null : onTap,
      child: Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          color: loading ? const Color(0xFFF2F2F2) : const Color(0xFFF9F9F9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.black.withOpacity(0.1),
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: loading
            ? const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.black,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 32,
                    color: Colors.black26,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isEmpty ? "AJOUTER DES IMAGES" : "AJOUTER PLUS D'IMAGES",
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      color: Colors.black38,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
