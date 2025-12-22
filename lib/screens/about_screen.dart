import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/layout_container.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  // Contrôleur statique pour synchroniser Scrollbar et ScrollView
  static final ScrollController _scrollController = ScrollController();

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.black, size: 22),
          onPressed: () => context.go('/'),
        ),
      ),
      body: RawScrollbar(
        controller: _scrollController,
        thumbColor: Colors.black.withOpacity(0.15),
        thickness: 5,
        radius: const Radius.circular(10),
        padding: const EdgeInsets.only(right: 2),
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          child: LayoutContainer(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // --- HEADER SECTION ---
                  const Text(
                    "L'Ingénierie de la\nPrécision.",
                    style: TextStyle(
                      fontSize: 44,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -2.0,
                      height: 1.05,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(height: 3, width: 40, color: Colors.black),
                  const SizedBox(height: 50),

                  // --- VISION SECTION ---
                  _buildSectionTitle("VISION"),
                  const Text(
                    "Je ne conçois pas de logiciel sans éthique. Mon ambition est de bâtir des systèmes complexes, de l'écosystème mobile au secteur spatial, privilégiant la performance brute et la protection absolue des données.",
                    style: TextStyle(
                      fontSize: 20,
                      height: 1.7,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // --- ARCHITECTURE SECTION ---
                  _buildSectionTitle("ARCHITECTURE & VALEURS"),
                  _buildBulletPoint("Souveraineté Numérique",
                      "Approche 'Offline-first' radicale : zéro tracking, zéro fuite de données."),
                  _buildBulletPoint("Craftsmanship",
                      "Architecture atomique et évolutive pour éliminer les structures monolithiques."),
                  _buildBulletPoint("Intelligence Embarquée",
                      "IA locale via TFLite et SQLite pour une indépendance totale et des modèles optimisés pour le spatial."),

                  const SizedBox(height: 40),

                  // --- PARCOURS SECTION ---
                  _buildSectionTitle("HÉRITAGE MÉCATRONIQUE"),
                  const Text(
                    "Diplômé de l'INSA et spécialisé en Systèmes Satellitaires, j'évolue à l'intersection du hardware et du software. Du bas-niveau (C/Assembleur) au haut-niveau (Flutter/Unity), je développe des systèmes résilients, portés par une exigence technique constante.",
                    style: TextStyle(
                        fontSize: 17, height: 1.6, color: Colors.black54),
                  ),

                  const SizedBox(height: 50),

                  // --- OUTILS DE CRÉATION ---
                  _buildSectionTitle("STACK TECHNIQUE"),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      "Flutter (Mobile & Desktop)",
                      "Dart",
                      "Supabase",
                      "Unity",
                      "Fusion 360",
                      "C#",
                      "IA Embarquée",
                      "SQLite",
                      "TFLite",
                      "Python",
                      "Git",
                      "Blender",
                      "Vercel Deployment",
                      "Keystore Management",
                      "VS Code",
                      "Google Colab",
                    ]
                        .map((tech) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: Colors.black.withOpacity(0.08)),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                tech.toUpperCase(),
                                style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.0),
                              ),
                            ))
                        .toList(),
                  ),

                  const SizedBox(height: 60),
                  const Divider(color: Colors.black12, thickness: 1),
                  const SizedBox(height: 40),

                  // --- FOOTER / SOCIALS ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _SocialButton(
                        label: "GITHUB",
                        onTap: () =>
                            _launch("https://github.com/jorgeandrecastro"),
                      ),
                      _SocialButton(
                        label: "LINKEDIN",
                        onTap: () => _launch(
                            "https://www.linkedin.com/in/jorge-andre-castro-8a7b801bb/"),
                      ),
                      _SocialButton(
                        label: "EMAIL",
                        onTap: () => _launch("mailto:georgeandrec@gmail.com"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w900,
          color: Colors.black.withOpacity(0.3),
          letterSpacing: 2.5,
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5)),
          const SizedBox(height: 6),
          Text(desc,
              style: const TextStyle(
                  fontSize: 15, color: Colors.black54, height: 1.5)),
        ],
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SocialButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 11,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
          ),
        ),
      ),
    );
  }
}
