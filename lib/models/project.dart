class Project {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final String? videoUrl;
  final String? linkUrl;
  final List<String> tags;
  final List<String> gallery; // NOUVEAU : Collection d'images
  final bool isFeatured;

  Project({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    this.videoUrl,
    this.linkUrl,
    required this.tags,
    this.gallery = const [], // NOUVEAU : Par défaut liste vide
    this.isFeatured = false,
  });

  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? 'Sans titre',
      description: map['description']?.toString() ?? '',
      imageUrl: map['image_url'],
      videoUrl: map['video_url'],
      linkUrl: map['link_url'],
      isFeatured: map['is_featured'] ?? false,
      tags:
          (map['tags'] as List?)?.map((item) => item.toString()).toList() ?? [],
      gallery:
          (map['gallery'] as List?)?.map((item) => item.toString()).toList() ??
              [], // NOUVEAU
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'video_url': videoUrl,
      'link_url': linkUrl,
      'is_featured': isFeatured,
      'tags': tags,
      'gallery': gallery, // NOUVEAU : Envoi vers Supabase
    };
  }
}
