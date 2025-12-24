import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:learning_management_system/screens/edit_profile_screen.dart';
import 'package:learning_management_system/screens/course_details_screen.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class ProfileScreen extends StatefulWidget {
  final User user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User _user;
  String? _profileImagePath;
  Uint8List? _profileImageBytes; // For web platform

  // Colors
  static const Color primaryColor = Color(0xFFC02528);
  static Color get surfaceColor => Colors.white;
  static const Color textDark = Color(0xFF1F2937);
  static const Color textMuted = Color(0xFF6B7280);
  static const Color borderColor = Color(0xFFF3F4F6);

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    _loadProfileImage();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final currentUser = await AuthService.getCurrentUser();
    if (currentUser != null && mounted) {
      setState(() {
        _user = currentUser;
      });
    }
  }

  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();

    if (kIsWeb) {
      // For web, load base64 encoded image
      final base64Image = prefs.getString('profile_image_base64');
      if (base64Image != null) {
        try {
          setState(() {
            _profileImageBytes = base64Decode(base64Image);
          });
          print(
            'Profile image loaded from base64 (${_profileImageBytes!.length} bytes)',
          );
        } catch (e) {
          print('Error loading web image: $e');
          await prefs.remove('profile_image_base64');
        }
      }
    } else {
      // For mobile, load file path from app directory
      final imagePath = prefs.getString('profile_image_path');
      if (imagePath != null) {
        final file = File(imagePath);
        if (await file.exists()) {
          setState(() {
            _profileImagePath = imagePath;
          });
          print('Profile image loaded from: $imagePath');
        } else {
          await prefs.remove('profile_image_path');
          setState(() {
            _profileImagePath = null;
          });
        }
      }
    }
  }

  Future<void> _saveProfileImage(XFile imageFile) async {
    final prefs = await SharedPreferences.getInstance();

    if (kIsWeb) {
      // For web, save as base64 string (persistent in localStorage)
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);
      await prefs.setString('profile_image_base64', base64Image);
      setState(() {
        _profileImageBytes = bytes;
      });
      print('Profile image saved as base64 (${bytes.length} bytes)');
    } else {
      // For mobile, copy to app documents directory (permanent storage)
      try {
        final appDir = await getApplicationDocumentsDirectory();
        final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final savedImage = File('${appDir.path}/$fileName');

        // Copy the image to app directory
        final bytes = await imageFile.readAsBytes();
        await savedImage.writeAsBytes(bytes);

        // Save the permanent path
        await prefs.setString('profile_image_path', savedImage.path);
        setState(() {
          _profileImagePath = savedImage.path;
        });
        print('Profile image saved to: ${savedImage.path}');
      } catch (e) {
        print('Error saving image: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal menyimpan gambar')),
          );
        }
      }
    }
  }

  ImageProvider? _getProfileImage() {
    if (kIsWeb && _profileImageBytes != null) {
      return MemoryImage(_profileImageBytes!);
    } else if (!kIsWeb && _profileImagePath != null) {
      return FileImage(File(_profileImagePath!));
    }
    return null;
  }

  Widget _buildProfileAvatar() {
    final profileImage = _getProfileImage();

    return CircleAvatar(
      key: ValueKey(
        _profileImagePath ??
            _profileImageBytes?.hashCode.toString() ??
            'no_image',
      ),
      radius: 50,
      backgroundColor: Colors.grey.shade100,
      backgroundImage: profileImage,
      onBackgroundImageError: profileImage != null
          ? (exception, stackTrace) {
              print('Error loading profile image: $exception');
            }
          : null,
      child: _profileImagePath == null && _profileImageBytes == null
          ? Text(
              _user.fullName.isNotEmpty ? _user.fullName[0].toUpperCase() : 'U',
              style: GoogleFonts.lexend(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFC02528),
              ),
            )
          : null,
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);

      if (pickedFile != null) {
        print('Image picked: ${pickedFile.path}');
        await _saveProfileImage(pickedFile);
        print('Profile image saved successfully');
      }
    } catch (e) {
      print('Error picking image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Terjadi kesalahan saat memilih gambar'),
          ),
        );
      }
    }
  }

  void _showImagePickerDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Pilih Sumber Gambar', style: GoogleFonts.lexend()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera),
              title: Text('Kamera', style: GoogleFonts.lexend()),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text('Galeri', style: GoogleFonts.lexend()),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showEditOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Profil', style: GoogleFonts.lexend()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: Text('Edit Data Profil', style: GoogleFonts.lexend()),
              onTap: () async {
                Navigator.pop(context);
                final updatedUser = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfileScreen(user: _user),
                  ),
                );

                if (updatedUser != null && updatedUser is User) {
                  setState(() {
                    _user = updatedUser;
                  });
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text('Ubah Foto Profil', style: GoogleFonts.lexend()),
              onTap: () {
                Navigator.pop(context);
                _showImagePickerDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1F2937)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Profil Saya',
          style: GoogleFonts.lexend(
            color: const Color(0xFF1F2937),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_note_rounded, color: Color(0xFFC02528)),
            onPressed: _showEditOptions,
            tooltip: 'Edit Profil',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          children: [
            // Banner 1: Personal Data
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Profile Card
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: _buildProfileAvatar(),
                      ),
                      GestureDetector(
                        onTap: _showEditOptions,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Color(0xFFC02528),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _user.fullName,
                    style: GoogleFonts.lexend(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _user.nim, // Display NIM
                    style: GoogleFonts.lexend(
                      fontSize: 14,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem('Semester', _user.semester),
                      Container(
                        width: 1,
                        height: 40,
                        color: Colors.grey.shade200,
                      ),
                      _buildStatItem('IPK', _user.ipk),
                      Container(
                        width: 1,
                        height: 40,
                        color: Colors.grey.shade200,
                      ),
                      _buildStatItem('SKS', _user.sks),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Academic Info
                  _buildSectionHeader('Info Akademik'),
                  const SizedBox(height: 16),
                  _buildInfoTile(
                    Icons.school_outlined,
                    'Program Studi',
                    _user.prodi,
                  ),
                  _buildInfoTile(
                    Icons.account_balance_outlined,
                    'Fakultas',
                    _user.fakultas,
                  ),
                  _buildInfoTile(Icons.email_outlined, 'Email', _user.email),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Banner 2: Class Progress
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: _buildClassProgress(),
            ),

            const SizedBox(height: 24),

            // Settings
            _buildSectionHeader('Pengaturan'),
            const SizedBox(height: 16),
            _buildSettingsTile(Icons.lock_outline, 'Ganti Password', () {}),
            _buildSettingsTile(
              Icons.notifications_outlined,
              'Notifikasi',
              () {},
            ),
            _buildSettingsTile(Icons.help_outline, 'Bantuan', () {}),

            const SizedBox(height: 32),

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate back to Login Screen
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                    (Route<dynamic> route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade50,
                  foregroundColor: Colors.red,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'Keluar Aplikasi',
                  style: GoogleFonts.lexend(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.lexend(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFC02528),
          ),
        ),
        Text(
          label,
          style: GoogleFonts.lexend(
            fontSize: 12,
            color: const Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: GoogleFonts.lexend(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF1F2937),
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFC02528).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFFC02528), size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.lexend(
                    fontSize: 12,
                    color: const Color(0xFF9CA3AF),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.lexend(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF3F4F6)),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF4B5563), size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.lexend(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1F2937),
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF9CA3AF), size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildClassProgress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Progres Kelas',
          style: GoogleFonts.lexend(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textDark,
          ),
        ),
        const SizedBox(height: 16),

        // Class items
        _buildClassItem(
          code: 'D4SM-42-03',
          name: 'Desain Antarmuka',
          progress: 89,
          iconText: 'UI',
          color: Colors.orange,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CourseDetailsScreen(
                  courseTitle:
                      'DESAIN ANTARMUKA & PENGALAMAN PENGGUNA D4SM-42-03 [ADY]',
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 12),

        _buildClassItem(
          code: 'D4SM-41-GAB1',
          name: 'Kewarganegaraan',
          progress: 86,
          icon: Icons.local_library,
          color: primaryColor,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CourseDetailsScreen(
                  courseTitle: 'PENDIDIKAN KEWARGANEGARAAN D4SM-41-GAB1 [MKU]',
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 12),

        _buildClassItem(
          code: 'D4SM-44-02',
          name: 'Sistem Operasi',
          progress: 90,
          icon: Icons.terminal,
          color: Colors.blue,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CourseDetailsScreen(
                  courseTitle: 'SISTEM OPERASI D4SM-44-02 [TI]',
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildClassItem({
    required String code,
    required String name,
    required int progress,
    IconData? icon,
    String? iconText,
    required Color color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon box
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withValues(alpha: 0.2)),
              ),
              child: Stack(
                children: [
                  Center(
                    child: iconText != null
                        ? Text(
                            iconText,
                            style: GoogleFonts.lexend(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          )
                        : Icon(icon, size: 24, color: color),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.3),
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    code,
                    style: GoogleFonts.lexend(
                      fontSize: 10,
                      color: textMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    name,
                    style: GoogleFonts.lexend(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Progress bar
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress / 100,
                            backgroundColor: Colors.grey.shade200,
                            valueColor: AlwaysStoppedAnimation(color),
                            minHeight: 6,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '$progress%',
                        style: GoogleFonts.lexend(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
