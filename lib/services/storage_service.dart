import 'dart:typed_data';
// On importe supabase_flutter pour avoir accès à la classe FileOptions
import 'package:supabase_flutter/supabase_flutter.dart';
import '../supabase/supabase_client.dart';

class StorageService {
  Future<String> uploadImage(
      String fileName, Uint8List bytes, String contentType) async {
    // Nettoyage simple du nom de fichier pour éviter les caractères spéciaux
    final cleanFileName = fileName.replaceAll(RegExp(r'[^a-zA-Z0-9.]'), '_');
    final path =
        'projects/${DateTime.now().millisecondsSinceEpoch}_$cleanFileName';

    // Utilisation de uploadBinary avec FileOptions correctement défini
    await supabase.storage.from('portfolio-media').uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(contentType: contentType, upsert: true),
        );

    // Récupération de l'URL publique pour l'enregistrer en base de données
    return supabase.storage.from('portfolio-media').getPublicUrl(path);
  }
}
