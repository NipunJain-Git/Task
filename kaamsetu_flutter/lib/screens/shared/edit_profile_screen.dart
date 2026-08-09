import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../providers/app_provider.dart';
import '../../core/i18n.dart';
import '../../widgets/atoms.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameCtrl;
  late TextEditingController _radiusCtrl;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<AppProvider>().user!;
    _nameCtrl = TextEditingController(text: user.name);
    _radiusCtrl = TextEditingController(text: user.radiusKm.round().toString());
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _radiusCtrl.dispose();
    super.dispose();
  }

  void _save() {
    setState(() => _loading = true);
    final provider = context.read<AppProvider>();
    final radius = double.tryParse(_radiusCtrl.text) ?? 5.0;
    
    // Minimal mock save operation
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      provider.user!.name = _nameCtrl.text;
      provider.user!.radiusKm = radius;
      provider.notifyListeners();
      setState(() => _loading = false);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: KsText('Profile updated successfully')));
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<AppProvider>().lang;
    return Scaffold(
      appBar: AppBar(
        title: KsText(tr(lang, 'Edit Profile') == 'Edit Profile' ? 'Edit Profile' : tr(lang, 'Edit Profile'), style: GoogleFonts.notoSans(fontWeight: FontWeight.w700)),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: _nameCtrl,
            decoration: InputDecoration(
              labelText: tr(lang, 'Full Name') == 'Full Name' ? 'Full Name' : tr(lang, 'Full Name'),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _radiusCtrl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: tr(lang, 'Search Radius (km)') == 'Search Radius (km)' ? 'Search Radius (km)' : tr(lang, 'Search Radius (km)'),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 32),
          KsPrimaryButton(
            label: tr(lang, 'save'),
            onTap: _save,
            isLoading: _loading,
          ),
        ],
      ),
    );
  }
}
