import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'quiz_screen.dart';

class QuizReviewScreen extends StatefulWidget {
  const QuizReviewScreen({super.key});

  @override
  State<QuizReviewScreen> createState() => _QuizReviewScreenState();
}

class _QuizReviewScreenState extends State<QuizReviewScreen> {
  static const Color primaryColor = Color(0xFFBC4B4B);
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color subtleColor = Color(0xFFF3F4F6);
  static const Color textMain = Color(0xFF1F2937);
  static const Color textMuted = Color(0xFF6B7280);

  // Initial Data
  final List<QuizAttempt> _attempts = [
    QuizAttempt(
      status: 'Selesai',
      submittedDate: 'Kamis, 25 Feb 2021, 10:40',
      score: 85.0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 4,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Quiz Review 1',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Instructions Section
              _buildInstructions(),

              const SizedBox(height: 32),

              // Quiz Details Card
              Center(child: _buildQuizDetails()),

              const SizedBox(height: 32),

              // Attempts Section
              _buildAttemptsSection(),

              const SizedBox(height: 32),

              // Action Buttons
              _buildActionButtons(context),

              const SizedBox(height: 100), // Space for bottom nav
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  // ... (Keep existing helper methods like _buildInstructions and _buildQuizDetails unchanged in structure, but inside State class)

  Widget _buildInstructions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: GoogleFonts.inter(
              fontSize: 14,
              height: 1.6,
              color: textMain,
            ),
            children: [
              const TextSpan(
                text:
                    'Silahkan kerjakan kuis ini dalam waktu 15 menit sebagai nilai pertama komponen kuis. Jangan lupa klik tombol ',
              ),
              TextSpan(
                text: 'Submit Answer',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  color: primaryColor,
                ),
              ),
              const TextSpan(text: ' setelah menjawab seluruh pertanyaan.'),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Kerjakan sebelum hari Jum\'at, 26 Februari 2021 jam 23:59 WIB.',
          style: GoogleFonts.inter(fontSize: 13, color: textMuted),
        ),
      ],
    );
  }

  Widget _buildQuizDetails() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: subtleColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildDetailRow('TUTUP PADA', 'Jumat, 26 February 2021, 11:59 PM'),
          _buildDivider(),
          _buildDetailRow('BATAS WAKTU', '15 menit'),
          _buildDivider(),
          _buildDetailRow('METODE PENILAIAN', 'Nilai Tertinggi'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
              color: textMuted,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: textMain,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      width: 120,
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: const Color(0xFFE5E7EB),
    );
  }

  Widget _buildAttemptsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Percobaan Yang Sudah Di Lakukan',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textMain,
          ),
        ),
        const SizedBox(height: 16),

        // Attempts Table
        Container(
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E7EB)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              // Table Header
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: const BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Text(
                        'STATUS',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        'NILAI / 100.00',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        'TINJAU',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),

              // Table Rows
              if (_attempts.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Text(
                      'Belum ada percobaan',
                      style: GoogleFonts.inter(color: textMuted),
                    ),
                  ),
                )
              else
                ..._attempts.map((attempt) => _buildAttemptRow(attempt)),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Final Score (Uses MAX score from attempts)
        if (_attempts.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFDE68A)),
            ),
            child: Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textMain,
                  ),
                  children: [
                    const TextSpan(
                      text: 'Nilai Akhir Anda Untuk Kuis Ini Adalah ',
                    ),
                    TextSpan(
                      text:
                          '${_calculateMaxScore().toStringAsFixed(1)} / 100.00',
                      style: GoogleFonts.inter(color: primaryColor),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAttemptRow(QuizAttempt attempt) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  attempt.status,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textMain,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  attempt.submittedDate,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: textMuted,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFD1FAE5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  attempt.score.toStringAsFixed(1),
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF065F46),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Lihat',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: primaryColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _calculateMaxScore() {
    if (_attempts.isEmpty) return 0.0;
    return _attempts
        .map((e) => e.score)
        .reduce((curr, next) => curr > next ? curr : next);
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const QuizScreen()),
              );

              if (result != null && result is Map) {
                // Helper to format date
                String formatDate(DateTime date) {
                  // Simple formatting: Kamis, 25 Feb 2021, 10:40
                  // In a real app, use intl package
                  final List<String> months = [
                    'Jan',
                    'Feb',
                    'Mar',
                    'Apr',
                    'Mei',
                    'Jun',
                    'Jul',
                    'Ags',
                    'Sep',
                    'Okt',
                    'Nov',
                    'Des',
                  ];
                  final List<String> days = [
                    'Senin',
                    'Selasa',
                    'Rabu',
                    'Kamis',
                    'Jumat',
                    'Sabtu',
                    'Minggu',
                  ];

                  String dayName = days[date.weekday - 1];
                  String day = date.day.toString();
                  String month = months[date.month - 1];
                  String year = date.year.toString();
                  String hour = date.hour.toString().padLeft(2, '0');
                  String minute = date.minute.toString().padLeft(2, '0');

                  return '$dayName, $day $month $year, $hour:$minute';
                }

                setState(() {
                  _attempts.add(
                    QuizAttempt(
                      status: 'Selesai',
                      submittedDate: formatDate(result['date']),
                      score: result['score'],
                    ),
                  );
                });
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: subtleColor,
              foregroundColor: textMain,
              elevation: 1,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              'Ambil Kuis',
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: subtleColor,
              foregroundColor: textMain,
              elevation: 1,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              'Kembali Ke Kelas',
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        border: Border(
          top: BorderSide(color: const Color(0xFFE5E7EB), width: 1),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_outlined, 'Home', false),
              _buildNavItem(Icons.school, 'Kelas Saya', true),
              _buildNavItem(
                Icons.notifications_outlined,
                'Notifikasi',
                false,
                hasNotif: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    bool isActive, {
    bool hasNotif = false,
  }) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(icon, size: 24, color: isActive ? primaryColor : textMuted),
              if (hasNotif)
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      border: Border.all(color: surfaceColor, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: isActive ? primaryColor : textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class QuizAttempt {
  final String status;
  final String submittedDate;
  final double score;

  QuizAttempt({
    required this.status,
    required this.submittedDate,
    required this.score,
  });
}
