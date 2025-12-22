import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  // TODO: Remplace par tes clés API Supabase (Project Settings > API)
  static const String url = 'https://vlpmleejazhzpaocdwhr.supabase.co';
  static const String anonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZscG1sZWVqYXpoenBhb2Nkd2hyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjYyNDM2NTgsImV4cCI6MjA4MTgxOTY1OH0.dgwZbv1_L627vFTSWkqIAxZqkXaT-QEPj2k7FqugQgs';
}

final supabase = Supabase.instance.client;
