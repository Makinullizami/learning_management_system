import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MeetingDetailsScreen extends StatefulWidget {
  final String title;

  const MeetingDetailsScreen({
    super.key,
    this.title = 'Pengantar User Interface Design',
  });

  @override
  State<MeetingDetailsScreen> createState() => _MeetingDetailsScreenState();
}

class _MeetingDetailsScreenState extends State<MeetingDetailsScreen> {
  int _selectedTabIndex = 0; // 0: Lampiran Materi, 1: Tugas dan Kuis

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Center(
                      child: Text(
                        widget.title,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1F2937),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Description
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Deskripsi',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _getDescription(widget.title),
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: const Color(0xFF4B5563),
                            height: 1.6,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Tabs
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                    child: Row(
                      children: [
                        _buildTabItem(0, 'Lampiran Materi'),
                        _buildTabItem(1, 'Tugas dan Kuis'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Content Area
                  if (_selectedTabIndex == 0)
                    _buildMaterialList()
                  else
                    _buildEmptyState(),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, String title) {
    bool isSelected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTabIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: isSelected
                ? const Border(
                    bottom: BorderSide(color: Colors.black, width: 2),
                  )
                : null,
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected
                  ? const Color(0xFF1F2937)
                  : Colors.grey.shade500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMaterialList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildMaterialItem(
            icon: Icons.link,
            title: 'Zoom Meeting Syncronous',
            isDone: true,
          ),
          const SizedBox(height: 12),
          _buildMaterialItem(
            icon: Icons.description_outlined,
            title: 'Pengantar User Interface Design',
            isDone: true,
          ),
          const SizedBox(height: 12),
          _buildMaterialItem(
            icon: Icons.description_outlined,
            title: 'Empat Teori Dasar Antarmuka Pengguna',
            isDone: true,
          ),
          const SizedBox(height: 12),
          _buildMaterialItem(
            icon: Icons.description_outlined,
            title: 'Empat Teori Dasar Antarmuka Pengguna',
            isDone: true,
          ),
          const SizedBox(height: 12),
          _buildMaterialItem(
            icon: Icons.videocam_outlined,
            title: 'User Interface Design for Beginner',
            isDone: true,
          ),
          const SizedBox(height: 12),
          _buildMaterialItem(
            icon: Icons.link,
            title: '20 Prinsip Desain',
            isDone: true,
          ),
          const SizedBox(height: 12),
          _buildMaterialItem(
            icon: Icons.link,
            title: 'Best Practice UI Design',
            isDone: true,
          ),
        ],
      ),
    );
  }

  Widget _buildMaterialItem({
    required IconData icon,
    required String title,
    required bool isDone,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30), // Pill shape as in image
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 24, color: const Color(0xFF1F2937)),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: const Color(0xFF1F2937),
              ),
            ),
          ),
          if (isDone)
            const Icon(Icons.check_circle, color: Color(0xFF2ECC71), size: 24)
          else
            Icon(Icons.check_circle, color: Colors.grey.shade300, size: 24),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Using a placeholder icon/image since I don't have the exact illustration asset
          // Ideally this would be Image.asset('assets/no_tasks.png')
          Icon(
            Icons.person_off_rounded, // Placeholder for illustration
            size: 120,
            color: Colors.red.shade100,
          ),
          const SizedBox(height: 24),
          Text(
            'Tidak Ada Tugas Dan Kuis Hari Ini',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: const Color(0xFF1F2937),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _getDescription(String title) {
    if (title.contains('01 - Pengantar')) {
      return 'Antarmuka yang dibangun harus memperhatikan prinsip-prinsip desain yang ada. Hal ini diharapkan agar antarmuka yang dibangun bukan hanya menarik secara visual tetapi dengan memperhatikan kaidah-kaidah prinsip desain diharapkan akan mendukung pengguna dalam menggunakan produk secara baik. Pelajaran mengenai prinsip UID ini sudah pernah diajarkan dalam mata kuliah Implementasi Desain Antarmuka Pengguna tetap pada matakuliah ini akan direview kembali sehingga dapat menjadi bekal saat memasukki materi mengenai User Experience';
    } else if (title.contains('02 - Konsep')) {
      return 'Mempelajari konsep dasar user interface design meliputi layout, tipografi, warna, dan hierarki visual. Mahasiswa akan memahami bagaimana elemen-elemen visual bekerja sama untuk membentuk antarmuka yang koheren dan mudah digunakan.';
    } else if (title.contains('03 - Interaksi')) {
      return 'Fokus pada bagaimana pengguna berinteraksi dengan sistem. Membahas feedback visual, animasi transisi, gestures pada perangkat mobile, dan prinsip direct manipulation.';
    } else if (title.contains('04 - Ethnographic')) {
      return 'Metode observasi etnografi untuk memahami konteks pengguna. Bagaimana melakukan studi lapangan, wawancara kontekstual, dan menerjemahkan hasil temuan menjadi kebutuhan desain.';
    } else if (title.contains('05 - UID Testing')) {
      return 'Teknik pengujian antarmuka pengguna termasuk usability testing, heuristic evaluation, dan A/B testing untuk memvalidasi keputusan desain yang telah dibuat.';
    } else if (title.contains('06 - Assessment')) {
      return 'Evaluasi komprehensif terhadap pemahaman materi pertemuan 1-5. Assessment ini akan menguji kemampuan analisis dan penerapan prinsip desain pada studi kasus nyata.';
    }
    return 'Deskripsi materi belum tersedia untuk pertemuan ini.';
  }
}
