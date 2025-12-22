import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/portfolio_service.dart';
import '../models/project.dart';
import '../widgets/project_card.dart';
import '../widgets/layout_container.dart';
import '../widgets/filter_bar.dart'; // Nouvel import
import '../supabase/supabase_client.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  final PortfolioService _service = PortfolioService();
  String _selectedFilter = "Tous";
  final ScrollController _mainScrollController = ScrollController();

  @override
  void dispose() {
    _mainScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: supabase.auth.onAuthStateChange,
      builder: (context, authSnapshot) {
        final bool isAdmin = supabase.auth.currentUser != null;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text("MES PROJETS",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 5, // Plus d'espace pour le côté VIP
                  fontSize: 15,
                )),
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.black),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 18),
              onPressed: () => context.go('/'),
            ),
            actions: [
              IconButton(
                icon: Icon(isAdmin ? Icons.lock_open : Icons.lock_outline,
                    size: 20),
                onPressed: () => context.go('/login'),
              ),
            ],
          ),
          body: RawScrollbar(
            controller: _mainScrollController,
            thumbVisibility: true,
            thickness: 4,
            radius: const Radius.circular(10),
            thumbColor: Colors.black.withOpacity(0.15), // Très léger
            padding: const EdgeInsets.only(right: 2),
            child: CustomScrollView(
              controller: _mainScrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Section Filtres
                SliverToBoxAdapter(
                  child: LayoutContainer(
                    child: FutureBuilder<List<Project>>(
                      future: _service.getProjects(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return const SizedBox(height: 100);

                        final allProjects = snapshot.data!;
                        final tags = allProjects
                            .expand((p) => p.tags)
                            .toSet()
                            .toList()
                          ..sort();
                        final categories = ["Tous", ...tags];

                        return Column(
                          children: [
                            const SizedBox(height: 40),
                            FilterBar(
                              categories: categories,
                              selectedFilter: _selectedFilter,
                              onSelect: (value) =>
                                  setState(() => _selectedFilter = value),
                            ),
                            const SizedBox(height: 40),
                          ],
                        );
                      },
                    ),
                  ),
                ),

                // Section Grille
                FutureBuilder<List<Project>>(
                  future: _service.getProjects(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SliverFillRemaining(
                          child: Center(
                              child: CircularProgressIndicator(
                                  strokeWidth: 1, color: Colors.black)));
                    }

                    final projects = snapshot.data ?? [];
                    final filtered = _selectedFilter == "Tous"
                        ? projects
                        : projects
                            .where((p) => p.tags.contains(_selectedFilter))
                            .toList();

                    return SliverPadding(
                      padding: const EdgeInsets.only(bottom: 80),
                      sliver: SliverToBoxAdapter(
                        child: LayoutContainer(
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 450,
                              childAspectRatio: 0.85,
                              crossAxisSpacing: 30,
                              mainAxisSpacing: 50,
                            ),
                            itemCount: filtered.length,
                            itemBuilder: (context, index) =>
                                ProjectCard(project: filtered[index]),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
