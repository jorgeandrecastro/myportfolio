import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/project.dart';
import 'youtube_video_player.dart';

class ProjectCard extends StatelessWidget {
  final Project project;
  const ProjectCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final hasVideo = project.videoUrl != null && project.videoUrl!.isNotEmpty;

    return AspectRatio(
      aspectRatio: 1.4, // ⭐ Ratio responsive au lieu de hauteur fixe
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.black.withOpacity(0.04), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: InkWell(
            onTap: () => context.go('/project/${project.id}', extra: project),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- MÉDIA ---
                Flexible(
                  flex: 5, // ⭐ 5 parts pour l'image
                  child: SizedBox(
                    width: double.infinity,
                    child: hasVideo
                        ? YoutubeVideoPlayer(videoUrl: project.videoUrl!)
                        : (project.imageUrl != null
                            ? Image.network(
                                project.imageUrl!,
                                fit: BoxFit.cover,
                              )
                            : Container(color: Colors.grey[100])),
                  ),
                ),

                // --- CONTENU TEXTE ---
                Flexible(
                  flex: 4, // ⭐ 4 parts pour le contenu
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- TAG NOIR ---
                        if (project.tags.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              project.tags.first.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                letterSpacing: 1.1,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),

                        const SizedBox(height: 14),

                        Text(
                          project.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 19,
                            color: Color(0xFF121212),
                            letterSpacing: -0.6,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 10),

                        Expanded(
                          child: Text(
                            project.description,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                              height: 1.6,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        const SizedBox(height: 15),

                        // Footer
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "DÉCOUVRIR",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.3,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 14,
                              color: Colors.black.withOpacity(0.7),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
