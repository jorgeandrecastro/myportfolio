import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../models/project.dart';
import '../widgets/layout_container.dart';
import '../widgets/youtube_video_player.dart';
import '../supabase/auth.dart';
import '../services/portfolio_service.dart';

class ProjectScreen extends StatelessWidget {
  final Project project;
  const ProjectScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final isAdmin = AuthProvider().isAdmin;
    final hasVideo = project.videoUrl != null && project.videoUrl!.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          if (isAdmin) ...[
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () => context.go('/editor', extra: project),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _confirmDelete(context),
            ),
          ]
        ],
      ),
      // ON A SUPPRIMÉ LE WIDGET SCROLLBAR ICI
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: LayoutContainer(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // --- MÉDIA ---
                if (hasVideo)
                  YoutubeVideoPlayer(videoUrl: project.videoUrl!)
                else if (project.imageUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      project.imageUrl!,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                const SizedBox(height: 32),

                // --- TITRE ---
                Text(
                  project.title,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                ),

                const SizedBox(height: 16),

                // --- TAGS ---
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: project.tags
                      .map((t) => Chip(
                            label: Text(t),
                            backgroundColor: Colors.grey[100],
                            side: BorderSide.none,
                          ))
                      .toList(),
                ),

                const SizedBox(height: 32),
                const Divider(),
                const SizedBox(height: 32),

                // --- DESCRIPTION ---
                MarkdownBody(
                  data: project.description,
                  selectable: true,
                  shrinkWrap: true,
                  styleSheet:
                      MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                    p: const TextStyle(
                        fontSize: 18, height: 1.7, color: Colors.black87),
                    listBullet:
                        const TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),

                const SizedBox(height: 50),

                // --- BOUTON LIEN ---
                if (project.linkUrl != null && project.linkUrl!.isNotEmpty)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.open_in_new),
                      label: const Text("VISITER LE PROJET"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () => _launchURL(project.linkUrl!),
                    ),
                  ),

                const SizedBox(height: 100), // Marge pour un scroll propre
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- LOGIQUE (URL & SUPPRESSION) ---
  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Supprimer ?"),
        content: const Text("Voulez-vous vraiment supprimer ce projet ?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Annuler")),
          TextButton(
            onPressed: () async {
              await PortfolioService().deleteProject(project.id);
              if (context.mounted) {
                Navigator.pop(context);
                context.go('/portfolio');
              }
            },
            child: const Text("Supprimer", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
