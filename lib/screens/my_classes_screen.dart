import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'course_details_screen.dart';

class MyClassesScreen extends StatelessWidget {
  final VoidCallback onBack;

  const MyClassesScreen({super.key, required this.onBack});

  // Colors based on HTML design
  static const Color primaryColor = Color(0xFFC0392B);
  static const Color secondaryColor = Color(0xFFE74C3C);
  static const Color backgroundColor = Color(0xFFFFFFFF);
  static const Color surfaceColor = Color(0xFFF9FAFB);
  static const Color textDark = Color(0xFF111827);
  static const Color textMuted = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Column(
        children: [
          // Header
          _buildHeader(),

          // Divider
          Container(
            height: 4,
            width: double.infinity,
            color: Colors.grey.shade100,
          ),

          // Course List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
              children: [
                _buildCourseCard(
                  context: context,
                  semester: '2021/2',
                  title:
                      'DESAIN ANTARMUKA & PENGALAMAN PENGGUNA D4SM-42-03 [ADY]',
                  progress: 89,
                  imageColor: Colors.yellow.shade100,
                  accentColor: Colors.yellow.shade800,
                  icon: Icons.design_services,
                ),
                const SizedBox(height: 16),
                _buildCourseCard(
                  context: context,
                  semester: '2021/2',
                  title:
                      'PENDIDIKAN KEWARGANEGARAAN D4SM-41-GAB1 [BBO]. JUMAT 2',
                  progress: 86,
                  imageColor: Colors.red.shade100,
                  accentColor: Colors.red.shade600,
                  icon: Icons.flag,
                ),
                const SizedBox(height: 16),
                _buildCourseCard(
                  context: context,
                  semester: '2021/2',
                  title: 'SISTEM OPERASI\nD4SM-44-02 [DDS]',
                  progress: 90,
                  imageColor: Colors.blue.shade50,
                  accentColor: Colors.blue.shade600,
                  icon: Icons.computer,
                ),
                const SizedBox(height: 16),
                _buildCourseCard(
                  context: context,
                  semester: '2021/2',
                  title:
                      'PEMROGRAMAN PERANGKAT BERGERAK MULTIMEDIA D4SM-41-GAB1 [APJ]',
                  progress: 90,
                  imageColor: Colors.cyan.shade100,
                  accentColor: Colors.cyan.shade600,
                  icon: Icons.phone_android,
                ),
                const SizedBox(height: 16),
                _buildCourseCard(
                  context: context,
                  semester: '2021/2',
                  title:
                      'BAHASA INGGRIS: BUSINESS AND SCIENTIFIC D4SM-41-GAB1 [ARS]',
                  progress: 90,
                  imageColor: Colors.grey.shade100,
                  accentColor: Colors.grey.shade600,
                  icon: Icons.language,
                ),
                const SizedBox(height: 16),
                _buildCourseCard(
                  context: context,
                  semester: '2021/2',
                  title: 'PEMROGRAMAN MULTIMEDIA INTERAKTIF D4SM-43-04 [TPR]',
                  progress: 90,
                  imageColor: Colors.blue.shade600,
                  accentColor: Colors.white,
                  icon: Icons.code,
                  iconColor: Colors.white,
                ),
                const SizedBox(height: 16),
                _buildCourseCard(
                  context: context,
                  semester: '2021/2',
                  title: 'OLAH RAGA\nD3TT-44-02 [EYR]',
                  progress: 90,
                  imageColor: Colors.purple.shade200,
                  accentColor: Colors.purple.shade600,
                  icon: Icons.sports_basketball,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back Button
          GestureDetector(
            onTap: onBack,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: textDark,
                size: 24,
              ),
            ),
          ),

          // Title
          Text(
            'Kelas Saya',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textDark,
              letterSpacing: 0.5,
            ),
          ),

          // Empty spacer for balance
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildCourseCard({
    required BuildContext context,
    required String semester,
    required String title,
    required int progress,
    required Color imageColor,
    required Color accentColor,
    required IconData icon,
    Color? iconColor,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CourseDetailsScreen(courseTitle: title),
          ),
        );
      },
      child: Container(
        color: Colors.transparent, // Ensures tap target
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image / Icon Box
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: imageColor,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Icon(icon, size: 40, color: iconColor ?? accentColor),
              ),
            ),

            const SizedBox(width: 16),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 2),
                  Text(
                    semester,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: textMuted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Progress Bar
                  Stack(
                    children: [
                      Container(
                        height: 10,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: progress / 100,
                        child: Container(
                          height: 10,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$progress% Selesai',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: textMuted,
                    ),
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
