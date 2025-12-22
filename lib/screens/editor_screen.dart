import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'dart:ui';

import '../models/project.dart';
import '../services/admin_service.dart';
import '../services/storage_service.dart';
import '../widgets/layout_container.dart';

class EditorScreen extends StatefulWidget {
  final Project? project;
  const EditorScreen({super.key, this.project});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();

  late TextEditingController _titleCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _linkCtrl;
  late TextEditingController _videoCtrl;
  late TextEditingController _tagsCtrl;

  String? _imageUrl;
  bool _isFeatured = false; // AJOUTÉ : État local pour le projet VIP
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final p = widget.project;
    _titleCtrl = TextEditingController(text: p?.title ?? '');
    _descCtrl = TextEditingController(text: p?.description ?? '');
    _linkCtrl = TextEditingController(text: p?.linkUrl ?? '');
    _videoCtrl = TextEditingController(text: p?.videoUrl ?? '');
    _tagsCtrl = TextEditingController(text: p?.tags.join(', ') ?? '');
    _imageUrl = p?.imageUrl;
    _isFeatured = p?.isFeatured ?? false; // RÉCUPÉRATION : du champ isFeatured
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _linkCtrl.dispose();
    _videoCtrl.dispose();
    _tagsCtrl.dispose();
    super.dispose();
  }

  InputDecoration _vipInput(String label, {IconData? icon}) {
    return InputDecoration(
      labelText: label.toUpperCase(),
      labelStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 10,
          letterSpacing: 1.5,
          fontWeight: FontWeight.bold),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      filled: true,
      fillColor: const Color(0xFFF9F9F9),
      prefixIcon:
          icon != null ? Icon(icon, size: 18, color: Colors.black) : null,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.black.withOpacity(0.05)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.black, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 0.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (image != null) {
      setState(() => _loading = true);
      try {
        final bytes = await image.readAsBytes();
        final mime = lookupMimeType(image.path) ?? 'image/jpeg';
        final url = await StorageService().uploadImage(image.name, bytes, mime);
        setState(() => _imageUrl = url);
      } catch (e) {
        if (mounted)
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Erreur upload: $e")));
      } finally {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final tags = _tagsCtrl.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      final data = {
        'title': _titleCtrl.text,
        'description': _descCtrl.text,
        'link_url': _linkCtrl.text.isEmpty ? null : _linkCtrl.text,
        'video_url': _videoCtrl.text.isEmpty ? null : _videoCtrl.text,
        'image_url': _imageUrl,
        'tags': tags,
        'is_featured':
            _isFeatured, // ENVOI : Mise à jour de la colonne Supabase
      };

      await AdminService().upsertProject(widget.project, data);
      if (mounted) context.go('/portfolio');
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Erreur sauvegarde: $e")));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: RawScrollbar(
        controller: _scrollController,
        thumbColor: Colors.black.withOpacity(0.2),
        thickness: 4,
        radius: const Radius.circular(10),
        padding: const EdgeInsets.only(right: 2, top: 70, bottom: 10),
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          child: LayoutContainer(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 110, 24, 60),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionHeader("Mise en avant"),
                    _buildFeaturedSwitch(), // AJOUTÉ : Le Switch VIP

                    const SizedBox(height: 40),
                    _sectionHeader("Visuel de couverture"),
                    _buildImagePicker(),

                    const SizedBox(height: 40),
                    _sectionHeader("Détails du projet"),
                    _buildTextFields(),

                    const SizedBox(height: 40),
                    _sectionHeader("Média & Références"),
                    _buildMediaFields(),

                    const SizedBox(height: 56),
                    _buildSaveButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- NOUVEAU WIDGET : SWITCH APPLE LUXE ---
  Widget _buildFeaturedSwitch() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _isFeatured ? Colors.black.withOpacity(0.02) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: _isFeatured ? Colors.black : Colors.black12, width: 1.5),
      ),
      child: SwitchListTile(
        title: const Text("METTRE EN AVANT (HOME PAGE)",
            style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1)),
        subtitle: const Text(
            "Le projet apparaîtra dans la section VIP de l'accueil.",
            style: TextStyle(fontSize: 10, color: Colors.grey)),
        value: _isFeatured,
        activeColor: Colors.black,
        contentPadding: EdgeInsets.zero,
        onChanged: (bool value) => setState(() => _isFeatured = value),
      ),
    );
  }

  // --- AUTRES COMPOSANTS (LOGIQUE PRÉSERVÉE) ---

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AppBar(
            title: Text(
                (widget.project == null ? "Nouveau Projet" : "Édition")
                    .toUpperCase(),
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2.5)),
            centerTitle: true,
            backgroundColor: Colors.white.withOpacity(0.7),
            foregroundColor: Colors.black,
            elevation: 0,
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 240,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.black.withOpacity(0.05)),
        ),
        child: _imageUrl != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Image.network(_imageUrl!, fit: BoxFit.cover))
            : const Center(
                child: Icon(Icons.add_a_photo_outlined, color: Colors.black26)),
      ),
    );
  }

  Widget _buildTextFields() {
    return Column(children: [
      TextFormField(
        controller: _titleCtrl,
        decoration:
            _vipInput("Nom du projet", icon: Icons.auto_awesome_outlined),
        style: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20, letterSpacing: -0.5),
        validator: (v) => v!.isEmpty ? 'Titre requis' : null,
      ),
      const SizedBox(height: 24),
      TextFormField(
        controller: _descCtrl,
        maxLines: 8,
        decoration: _vipInput("Description"),
        style:
            const TextStyle(height: 1.7, fontSize: 15, color: Colors.black87),
        validator: (v) => v!.isEmpty ? 'Description requise' : null,
      ),
      const SizedBox(height: 24),
      TextFormField(
        controller: _tagsCtrl,
        decoration: _vipInput("Expertises (Tags)", icon: Icons.api_outlined),
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    ]);
  }

  Widget _buildMediaFields() {
    return Column(children: [
      TextFormField(
          controller: _videoCtrl,
          decoration: _vipInput("Lien Vidéo (YouTube)",
              icon: Icons.play_circle_outline_rounded)),
      const SizedBox(height: 24),
      TextFormField(
          controller: _linkCtrl,
          decoration: _vipInput("Lien du projet (Live)",
              icon: Icons.north_east_rounded)),
    ]);
  }

  Widget _buildSaveButton() {
    return _loading
        ? const Center(child: CircularProgressIndicator(color: Colors.black))
        : SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 26),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: _save,
              child: Text("Publier les modifications".toUpperCase(),
                  style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 3,
                      fontSize: 11)),
            ),
          );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 16),
      child: Text(title.toUpperCase(),
          style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              color: Colors.black45)),
    );
  }
}
