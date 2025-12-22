import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/layout_container.dart';
import '../widgets/project_card.dart';
import '../services/portfolio_service.dart';
import '../models/project.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Project> _featuredProjects = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFeatured();
  }

  Future<void> _loadFeatured() async {
    try {
      final projects = await PortfolioService().getFeaturedProjects();
      if (mounted) {
        setState(() {
          _featuredProjects = projects;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              const Color(0xFFFAFAFA),
              Colors.white,
              Colors.white,
            ],
            stops: const [0.0, 0.2, 1.0],
          ),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: LayoutContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth > 900;

                      if (isWide &&
                          !_isLoading &&
                          _featuredProjects.isNotEmpty) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 6,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildAvailabilityBadge(),
                                  const SizedBox(height: 24),
                                  _buildHeroTitle(),
                                  const SizedBox(height: 20),
                                  _buildSubTitle(),
                                  const SizedBox(height: 40),
                                  _buildActionButtons(context),
                                ],
                              ),
                            ),
                            const SizedBox(width: 80),
                            Expanded(
                              flex: 5,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 52),
                                child: SizedBox(
                                  height: 450,
                                  child: ProjectCard(
                                    project: _featuredProjects.first,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildAvailabilityBadge(),
                          const SizedBox(height: 24),
                          _buildHeroTitle(),
                          const SizedBox(height: 20),
                          _buildSubTitle(),
                          const SizedBox(height: 40),
                          _buildActionButtons(context),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 100),
                if (_isLoading || _featuredProjects.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 32,
                      right: 32,
                      bottom: 8,
                    ),
                    child: _sectionHeader("Projets à la une"),
                  ),
                  const SizedBox(height: 32),
                  _buildFeaturedList(),
                  const SizedBox(height: 80),
                ],
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: _buildFooter(),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedList() {
    if (_isLoading) {
      return const SizedBox(
        height: 300,
        child: Center(
          child: CircularProgressIndicator(
            color: Colors.black,
            strokeWidth: 1,
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 900;
        final projectsToShow = isWide && _featuredProjects.isNotEmpty
            ? _featuredProjects.skip(1).toList()
            : _featuredProjects;

        return Column(
          children: projectsToShow.asMap().entries.map((entry) {
            final index = entry.key;
            final project = entry.value;
            final isEven = index % 2 == 0;

            return Padding(
              padding: EdgeInsets.only(
                left: isEven ? 80 : 32,
                right: isEven ? 32 : 80,
                bottom: 64,
              ),
              child: ProjectCard(project: project),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildAvailabilityBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.04),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: Colors.black.withOpacity(0.08),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            "Actuellement disponible pour de nouveaux projets",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroTitle() {
    return const Text(
      "Jorge Andre Castro",
      style: TextStyle(
        fontSize: 52,
        fontWeight: FontWeight.w600,
        color: Color(0xFF0A0A0A),
        height: 1.1,
        letterSpacing: -2,
      ),
    );
  }

  Widget _buildSubTitle() {
    return Text(
      "Ingénieur en devenir spécialisé en Systèmes Satellitaires.\nJe conçois des systèmes hybrides à la confluence de la mécatronique, du logiciel embarqué (C/Assembleur) et du développement Full-Stack. Mon approche intègre l'intelligence artificielle locale et la modélisation 3D avancée pour créer des solutions résilientes.\n\nPassionné par les CubeSats et l'expérimentation concrète, je m'efforce de repousser les limites de l'ingénierie spatiale en construisant des systèmes innovants, de la première ligne de code au hardware final.",
      style: TextStyle(
        fontSize: 15,
        color: Colors.black.withOpacity(0.7),
        height: 1.6,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.2,
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(
                horizontal: 28,
                vertical: 18,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => context.go('/portfolio'),
            child: const Text(
              "Explorer le portfolio",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                letterSpacing: -0.2,
                fontSize: 14,
              ),
            ),
          ),
        ),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.black,
            side: BorderSide(
              color: Colors.black.withOpacity(0.15),
              width: 1,
            ),
            elevation: 0,
            padding: const EdgeInsets.symmetric(
              horizontal: 28,
              vertical: 18,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () => context.go('/about'),
          child: Text(
            "Profil et Vision",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              letterSpacing: -0.2,
              fontSize: 14,
              color: Colors.black.withOpacity(0.8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _sectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        color: Colors.black,
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 0.5,
          color: Colors.black.withOpacity(0.06),
        ),
        const SizedBox(height: 24),
        Text(
          "© 2025 • Jorge Andre Castro • Développé avec Flutter",
          style: TextStyle(
            color: Colors.black.withOpacity(0.35),
            fontSize: 11,
            fontWeight: FontWeight.w400,
            letterSpacing: -0.1,
          ),
        ),
      ],
    );
  }
}
