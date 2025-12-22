class Project {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final String? videoUrl;
  final String? linkUrl;
  final List<String> tags;
  final bool isFeatured; // AJOUTÉ : Pour la mise en avant Apple Pro Luxe

  Project({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    this.videoUrl,
    this.linkUrl,
    required this.tags,
    this.isFeatured = false, // Par défaut à false
  });

  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? 'Sans titre',
      description: map['description']?.toString() ?? '',
      imageUrl: map['image_url'],
      videoUrl: map['video_url'],
      linkUrl: map['link_url'],
      isFeatured: map['is_featured'] ?? false, // RÉCUPÉRATION : du booléen
      tags:
          (map['tags'] as List?)?.map((item) => item.toString()).toList() ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'video_url': videoUrl,
      'link_url': linkUrl,
      'is_featured': isFeatured, // ENVOI : vers Supabase
      'tags': tags,
    };
  }
}
