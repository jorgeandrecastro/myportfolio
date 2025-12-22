import '../supabase/supabase_client.dart';
import '../models/project.dart';

class PortfolioService {
  // Récupère tous les projets pour la page Portfolio
  Future<List<Project>> getProjects() async {
    final response = await supabase
        .from('projects')
        .select()
        .order('created_at', ascending: false);

    final List<dynamic> data = response as List<dynamic>;
    // Utilisation de fromMap (ou fromJson selon ton modèle)
    return data.map((e) => Project.fromMap(e)).toList();
  }

  // RÉCUPÈRE LES 3 PROJETS "FEATURED" POUR LA HOME
  Future<List<Project>> getFeaturedProjects() async {
    final response = await supabase
        .from('projects')
        .select()
        .eq('is_featured', true) // Filtre pour le mode Luxe/VIP
        .limit(3) // On en prend 3 max
        .order('created_at', ascending: false);

    final List<dynamic> data = response as List<dynamic>;
    return data.map((e) => Project.fromMap(e)).toList();
  }

  // Supprimer un projet
  Future<void> deleteProject(String id) async {
    await supabase.from('projects').delete().eq('id', id);
  }
}
