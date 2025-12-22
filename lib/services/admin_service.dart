import '../supabase/supabase_client.dart';
import '../models/project.dart';

class AdminService {
  Future<void> login(String email, String password) async {
    await supabase.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> upsertProject(
      Project? existingProject, Map<String, dynamic> data) async {
    if (existingProject != null) {
      // Update
      await supabase.from('projects').update(data).eq('id', existingProject.id);
    } else {
      // Create
      await supabase.from('projects').insert(data);
    }
  }
}
