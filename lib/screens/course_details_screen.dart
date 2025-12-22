import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'meeting_details_screen.dart';

class CourseDetailsScreen extends StatefulWidget {
  final String courseTitle;
  final VoidCallback? onBack;

  const CourseDetailsScreen({
    super.key,
    this.courseTitle =
        'DESAIN ANTARMUKA & PENGALAMAN PENGGUNA D4SM-42-03 [ADY]',
    this.onBack,
  });

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  int _selectedTabIndex = 0; // 0: Materi, 1: Tugas

  // Colors based on HTML design
  static const Color primaryColor = Color(0xFFBD403F);
  static const Color backgroundColor = Color(0xFFF0F2F5);
  static const Color cardColor = Colors.white;
  static const Color badgeBlue = Color(0xFF5DADE2);
  static const Color textDark = Color(0xFF1F2937); // Generalized dark text
  static const Color textMuted = Color(0xFF9CA3AF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          Column(
            children: [
              // Header Area with Custom Height
              Container(
                color: primaryColor,
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 10,
                  left: 24,
                  right: 24,
                  bottom: 64, // Space for the floating tab bar
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (widget.onBack != null) {
                          widget.onBack!();
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        widget.courseTitle,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600, // Semibold
                          color: Colors.white,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30), // Space for floating tab overlapping
              // Content Area (Switchable)
              Expanded(
                child: _selectedTabIndex == 0
                    ? _buildMateriList()
                    : _buildTugasList(),
              ),
            ],
          ),

          // Floating Tab Bar
          Positioned(
            top:
                MediaQuery.of(context).padding.top +
                80, // Adjust based on header content
            left: 20,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  _buildTabItem(0, 'Materi'),
                  _buildTabItem(1, 'Tugas Dan Kuis'),
                ],
              ),
            ),
          ),

          // Bottom Navigation Replica Removed (Integrated into HomeScreen)
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
          color: Colors.transparent, // Hit test
          child: Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? textDark : Colors.grey.shade400,
                  ),
                ),
              ),
              if (isSelected)
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: 60,
                    height: 4,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(4),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMateriList() {
    if (widget.courseTitle.contains('KEWARGANEGARAAN')) {
      return _buildKewarganegaraanMateri();
    } else if (widget.courseTitle.contains('SISTEM OPERASI')) {
      return _buildSistemOperasiMateri();
    }
    return _buildUIDesignMateri();
  }

  Widget _buildTugasList() {
    if (widget.courseTitle.contains('KEWARGANEGARAAN')) {
      return _buildKewarganegaraanTugas();
    } else if (widget.courseTitle.contains('SISTEM OPERASI')) {
      return _buildSistemOperasiTugas();
    }
    return _buildUIDesignTugas();
  }

  // --- UI Design Content ---
  Widget _buildUIDesignMateri() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        _buildMateriCard(
          badgeText: 'Pertemuan 1',
          title: '01 - Pengantar User Interface Design',
          subtitle: '3 URLs, 2 Files, 3 Interactive Content',
          isDone: true,
          badgeColor: badgeBlue,
        ),
        const SizedBox(height: 16),
        _buildMateriCard(
          badgeText: 'Pertemuan 2',
          title: '02 - Konsep User Interface Design',
          subtitle: '2 URLs, 1 Kuis, 3 Files, 1 Tugas',
          isDone: true,
          badgeColor: badgeBlue,
        ),
        const SizedBox(height: 16),
        _buildMateriCard(
          badgeText: 'Pertemuan 3',
          title: '03 - Interaksi pada User Interface Design',
          subtitle: '3 URLs, 2 Files, 3 Interactive Content',
          isDone: true,
          badgeColor: badgeBlue,
        ),
        const SizedBox(height: 16),
        _buildMateriCard(
          badgeText: 'Pertemuan 4',
          title: '04 - Ethnographic Observation',
          subtitle: '3 URLs, 2 Files, 3 Interactive Content',
          isDone: true,
          badgeColor: badgeBlue,
        ),
        const SizedBox(height: 16),
        _buildMateriCard(
          badgeText: 'Pertemuan 5',
          title: '05 - UID Testing',
          subtitle: '3 URLs, 2 Files, 3 Interactive Content',
          isDone: true,
          badgeColor: badgeBlue,
        ),
        const SizedBox(height: 16),
        _buildMateriCard(
          badgeText: 'Pertemuan 6',
          title: '06 - Assessment 1',
          subtitle: '3 URLs, 2 Files, 3 Interactive Content',
          isDone: true,
          badgeColor: badgeBlue,
        ),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildUIDesignTugas() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        _buildTugasCard(
          badgeText: 'Quiz',
          isDone: true,
          icon: Icons.chat_bubble_outline_rounded,
          title: 'Quiz Review 01',
          dueDate: '26 Februari 2021 23:59 WIB',
        ),
        const SizedBox(height: 16),
        _buildTugasCard(
          badgeText: 'Tugas',
          isDone: false,
          icon: Icons.assignment_outlined,
          title: 'Tugas 01 - UID Android Mobile Game',
          dueDate: '26 Februari 2021 23:59 WIB',
        ),
        const SizedBox(height: 100),
      ],
    );
  }

  // --- Kewarganegaraan Content ---
  Widget _buildKewarganegaraanMateri() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        _buildMateriCard(
          badgeText: 'Pertemuan 1',
          title: '01 - Pengantar Pendidikan Kewarganegaraan',
          subtitle: '1 URL, 2 Files',
          isDone: true,
          badgeColor: Colors.redAccent,
        ),
        const SizedBox(height: 16),
        _buildMateriCard(
          badgeText: 'Pertemuan 2',
          title: '02 - Identitas Nasional',
          subtitle: '2 URLs, 1 File',
          isDone: true,
          badgeColor: Colors.redAccent,
        ),
        const SizedBox(height: 16),
        _buildMateriCard(
          badgeText: 'Pertemuan 3',
          title: '03 - Negara dan Konstitusi',
          subtitle: '3 Files',
          isDone: false,
          badgeColor: Colors.redAccent,
        ),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildKewarganegaraanTugas() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        _buildTugasCard(
          badgeText: 'Tugas',
          isDone: false,
          icon: Icons.assignment_outlined,
          title: 'Makalah Analisis Masalah Bangsa',
          dueDate: '10 Maret 2021 23:59 WIB',
        ),
        const SizedBox(height: 100),
      ],
    );
  }

  // --- Sistem Operasi Content ---
  Widget _buildSistemOperasiMateri() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        _buildMateriCard(
          badgeText: 'Pertemuan 1',
          title: '01 - Pengenalan Sistem Operasi',
          subtitle: '2 URLs, 1 Video',
          isDone: true,
          badgeColor: Colors.blueAccent,
        ),
        const SizedBox(height: 16),
        _buildMateriCard(
          badgeText: 'Pertemuan 2',
          title: '02 - Struktur Sistem Operasi',
          subtitle: '1 URL, 2 Files',
          isDone: true,
          badgeColor: Colors.blueAccent,
        ),
        const SizedBox(height: 16),
        _buildMateriCard(
          badgeText: 'Pertemuan 3',
          title: '03 - Proses dan Thread',
          subtitle: '3 URLs, 1 Quiz',
          isDone: false,
          badgeColor: Colors.blueAccent,
        ),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildSistemOperasiTugas() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        _buildTugasCard(
          badgeText: 'Praktikum',
          isDone: true,
          icon: Icons.computer,
          title: 'Instalasi Linux Ubuntu',
          dueDate: '1 Maret 2021 23:59 WIB',
        ),
        const SizedBox(height: 16),
        _buildTugasCard(
          badgeText: 'Tugas',
          isDone: false,
          icon: Icons.assignment_outlined,
          title: 'Laporan Manajemen Proses',
          dueDate: '15 Maret 2021 23:59 WIB',
        ),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildMateriCard({
    required String badgeText,
    required String title,
    required String subtitle,
    required bool isDone,
    required Color badgeColor,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MeetingDetailsScreen(title: title),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Badge and Status Checkbox
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(
                      4,
                    ), // Slightly less rounded for Materi
                  ),
                  child: Text(
                    badgeText, // Not uppercased in Materi image
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDone ? Colors.green : Colors.grey.shade300,
                  ),
                  padding: const EdgeInsets.all(2),
                  child: const Icon(Icons.check, size: 16, color: Colors.white),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Title
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600, // Slightly bolder
                color: textDark,
                height: 1.3,
              ),
            ),

            const SizedBox(height: 8),

            // Subtitle
            Text(
              subtitle,
              style: GoogleFonts.poppins(
                fontSize: 10, // Small text
                color: textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTugasCard({
    required String badgeText,
    required bool isDone,
    required IconData icon,
    required String title,
    required String dueDate,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Badge and Status Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: badgeBlue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  badgeText.toUpperCase(),
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDone ? Colors.green : Colors.grey.shade300,
                ),
                padding: const EdgeInsets.all(2),
                child: const Icon(Icons.check, size: 16, color: Colors.white),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Main Content: Icon and Title
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 36, color: textDark.withOpacity(0.8)),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textDark,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          Divider(color: Colors.grey.shade200),
          const SizedBox(height: 8),

          // Footer: Due Date
          Text(
            'Tenggat Waktu : $dueDate',
            style: GoogleFonts.poppins(fontSize: 12, color: textMuted),
          ),
        ],
      ),
    );
  }
}
