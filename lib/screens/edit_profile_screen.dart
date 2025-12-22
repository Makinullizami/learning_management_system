import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;

  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _nimController;
  late TextEditingController _emailController;
  late TextEditingController _prodiController;
  late TextEditingController _fakultasController;
  late TextEditingController _semesterController;
  late TextEditingController _ipkController;
  late TextEditingController _sksController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.fullName);
    _nimController = TextEditingController(text: widget.user.nim);
    _emailController = TextEditingController(text: widget.user.email);
    _prodiController = TextEditingController(text: widget.user.prodi);
    _fakultasController = TextEditingController(text: widget.user.fakultas);
    _semesterController = TextEditingController(text: widget.user.semester);
    _ipkController = TextEditingController(text: widget.user.ipk);
    _sksController = TextEditingController(text: widget.user.sks);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nimController.dispose();
    _emailController.dispose();
    _prodiController.dispose();
    _fakultasController.dispose();
    _semesterController.dispose();
    _ipkController.dispose();
    _sksController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    setState(() => _isLoading = true);

    final updatedUser = User(
      fullName: _nameController.text,
      email: _emailController.text,
      password: widget.user.password, // Keep existing password
      nim: _nimController.text,
      prodi: _prodiController.text,
      fakultas: _fakultasController.text,
      semester: _semesterController.text,
      ipk: _ipkController.text,
      sks: _sksController.text,
    );

    final success = await AuthService.updateUser(updatedUser);

    setState(() => _isLoading = false);

    if (success && mounted) {
      Navigator.pop(context, updatedUser); // Return updated user
    } else if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gagal memperbarui profil')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          'Edit Profil',
          style: GoogleFonts.lexend(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1F2937),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1F2937)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveProfile,
            child: Text(
              'SIMPAN',
              style: GoogleFonts.lexend(
                fontWeight: FontWeight.bold,
                color: const Color(0xFFC02528),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildInputGroup('Info Pribadi', [
              _buildTextField('Nama Lengkap', _nameController),
              _buildTextField('NIM', _nimController),
              _buildTextField('Email', _emailController),
            ]),
            const SizedBox(height: 24),
            _buildInputGroup('Info Akademik', [
              _buildTextField('Program Studi', _prodiController),
              _buildTextField('Fakultas', _fakultasController),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField('Semester', _semesterController),
                  ),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField('IPK', _ipkController)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField('SKS', _sksController)),
                ],
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildInputGroup(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.lexend(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.lexend(
              fontSize: 12,
              color: const Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 0,
                vertical: 8,
              ),
              border: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFE5E7EB)),
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFE5E7EB)),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFC02528)),
              ),
            ),
            style: GoogleFonts.lexend(
              fontSize: 14,
              color: const Color(0xFF1F2937),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
