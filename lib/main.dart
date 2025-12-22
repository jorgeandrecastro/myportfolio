import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Ajouté pour le contrôle de la couleur du haut
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Imports internes
import 'supabase/supabase_client.dart';
import 'supabase/auth.dart';
import 'models/project.dart';
import 'screens/home_screen.dart';
import 'screens/portfolio_screen.dart';
import 'screens/project_screen.dart';
import 'screens/about_screen.dart';
import 'screens/admin_login_screen.dart';
import 'screens/editor_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // URL propre pour le web
  usePathUrlStrategy();

  // Initialisation Supabase
  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );

  runApp(const MyApp());
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(
        path: '/portfolio',
        builder: (context, state) => const PortfolioScreen()),
    GoRoute(path: '/about', builder: (context, state) => const AboutScreen()),
    GoRoute(
        path: '/login', builder: (context, state) => const AdminLoginScreen()),
    GoRoute(
      path: '/editor',
      builder: (context, state) {
        if (!AuthProvider().isAdmin) return const AdminLoginScreen();
        final project = state.extra as Project?;
        return EditorScreen(project: project);
      },
    ),
    GoRoute(
      path: '/project/:id',
      builder: (context, state) {
        final project = state.extra as Project?;
        if (project == null) {
          return const Scaffold(
            body: Center(child: Text("Projet non trouvé.")),
          );
        }
        return ProjectScreen(project: project);
      },
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Mon Portfolio ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.interTextTheme(),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,

        // --- CONFIGURATION DU HAUT (AppBar & Barre de statut) ---
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white, // Empêche la teinte grise sur scroll
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent, // Rend le haut transparent
            statusBarIconBrightness:
                Brightness.dark, // Icônes noires (batterie/heure)
            statusBarBrightness: Brightness.light, // Pour iOS
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ),
      routerConfig: _router,
    );
  }
}
