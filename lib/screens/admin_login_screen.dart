import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/admin_service.dart';
import '../widgets/layout_container.dart';
import '../supabase/auth.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _adminService = AdminService();

  bool _loading = false;
  bool _obscureText = true;

  static const List<String> _systemFonts = [
    '-apple-system',
    'BlinkMacSystemFont',
    'Segoe UI',
    'Roboto',
    'Helvetica Neue',
    'Arial',
    'sans-serif',
  ];

  Future<void> _handleLogin() async {
    if (_emailCtrl.text.isEmpty || _passCtrl.text.isEmpty) return;

    setState(() => _loading = true);
    try {
      await _adminService.login(_emailCtrl.text, _passCtrl.text);
      if (mounted) context.go('/portfolio');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erreur : ${e.toString()}"),
            backgroundColor: Colors.red[800],
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = AuthProvider();

    if (auth.isAdmin) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.verified_user_rounded,
                  size: 80, color: Colors.teal[700]),
              const SizedBox(height: 24),
              Text("Connecté en tant que",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontFamilyFallback: _systemFonts)),
              const SizedBox(height: 8),
              Text(auth.user?.email ?? '',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      fontFamilyFallback: _systemFonts)),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                icon: const Icon(Icons.logout, color: Colors.redAccent),
                label: const Text("Déconnexion",
                    style: TextStyle(color: Colors.redAccent)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[50],
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () async {
                  await auth.signOut();
                  setState(() {});
                },
              ),
              const SizedBox(height: 16),
              TextButton(
                  onPressed: () => context.go('/portfolio'),
                  child: const Text("Retour au Portfolio")),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF0F4F8), Color(0xFFE2E8ED)],
          ),
        ),
        child: Center(
          child: LayoutContainer(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(36),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    // Padding plus équilibré et sophistiqué
                    padding: const EdgeInsets.fromLTRB(56, 72, 56, 64),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withOpacity(0.85),
                          Colors.white.withOpacity(0.65),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(36),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.7), width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 50,
                          offset: const Offset(0, 30),
                          spreadRadius: 0,
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Titre avec plus d'air au-dessus
                        Text(
                          "Accès Administrateur",
                          style: TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.8,
                            color: Colors.grey[900],
                            fontFamilyFallback: _systemFonts,
                            shadows: const [
                              Shadow(
                                  color: Colors.black26,
                                  offset: Offset(0, 2),
                                  blurRadius: 4)
                            ],
                          ),
                        ),
                        const SizedBox(height: 16), // plus respirant

                        Text(
                          "Connectez-vous pour gérer le portfolio",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[700],
                            letterSpacing: 0.3,
                            fontFamilyFallback: _systemFonts,
                          ),
                        ),
                        const SizedBox(
                            height: 64), // espace généreux avant les champs

                        // Champs rapprochés entre eux (groupe logique)
                        TextField(
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(fontFamilyFallback: _systemFonts),
                          decoration: InputDecoration(
                            labelText: "Email",
                            hintText: "admin@exemple.com",
                            prefixIcon:
                                const Icon(Icons.mail_outline, size: 22),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.7),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Colors.grey[400]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                  color: Colors.black87, width: 2),
                            ),
                          ),
                        ),
                        const SizedBox(
                            height: 24), // plus serré entre les deux champs

                        TextField(
                          controller: _passCtrl,
                          obscureText: _obscureText,
                          style: TextStyle(fontFamilyFallback: _systemFonts),
                          decoration: InputDecoration(
                            labelText: "Mot de passe",
                            prefixIcon:
                                const Icon(Icons.lock_outline, size: 22),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.7),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Colors.grey[400]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                  color: Colors.black87, width: 2),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                  _obscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  size: 22),
                              onPressed: () =>
                                  setState(() => _obscureText = !_obscureText),
                            ),
                          ),
                        ),

                        const SizedBox(
                            height: 64), // grand souffle avant le bouton

                        // Bouton raffiné
                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: _loading ? null : _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              shadowColor: Colors.transparent,
                            ).copyWith(
                              overlayColor:
                                  WidgetStateProperty.resolveWith((states) {
                                if (states.contains(WidgetState.hovered))
                                  return Colors.white.withOpacity(0.12);
                                return null;
                              }),
                            ),
                            child: _loading
                                ? const CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 3)
                                : const Text(
                                    "Se connecter",
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.8,
                                      fontFamilyFallback: _systemFonts,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
