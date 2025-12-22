import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_client.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;

  // Getter pour récupérer l'utilisateur actuel
  User? get user => _user;

  // Vérifie si l'utilisateur est connecté (Admin)
  bool get isAdmin => _user != null;

  AuthProvider() {
    _init();
  }

  void _init() {
    // 1. Récupération immédiate de la session actuelle au démarrage
    _user = supabase.auth.currentUser;

    // 2. Écoute en temps réel des changements d'état
    supabase.auth.onAuthStateChange.listen((data) {
      final Session? session = data.session;
      _user = session?.user;

      // Très important : prévient tous les widgets qui utilisent l'admin
      notifyListeners();
    });
  }

  // Fonction de connexion (à utiliser dans ton AdminLoginScreen)
  Future<void> signIn(String email, String password) async {
    try {
      await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow; // On renvoie l'erreur pour l'afficher dans l'UI
    }
  }

  // Fonction de déconnexion
  Future<void> signOut() async {
    await supabase.auth.signOut();
    // Le listener _init s'occupera du notifyListeners()
  }
}
