import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'quiz_screen.dart'; // Import to access QuizQuestion class

class QuizAnswerReviewScreen extends StatelessWidget {
  final List<QuizQuestion> questions;
  final Map<int, int> selectedAnswers;
  final int timeTakenSeconds;

  const QuizAnswerReviewScreen({
    super.key,
    required this.questions,
    required this.selectedAnswers,
    required this.timeTakenSeconds,
  });

  static const Color primaryColor = Color(0xFFC54E4E);
  static const Color backgroundColor = Color(0xFFFAFAFA);
  static const Color textMain = Color(0xFF1F2937);
  static const Color textMuted = Color(0xFF6B7280);

  String _formatDuration(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes Menit $remainingSeconds Detik';
  }

  void _submitFinal(BuildContext context) {
    // Calculate Score
    int correctAnswers = 0;
    selectedAnswers.forEach((questionIndex, selectedOptionIndex) {
      if (questions[questionIndex].correctOptionIndex == selectedOptionIndex) {
        correctAnswers++;
      }
    });

    double score = (correctAnswers / questions.length) * 100;

    // Show Result Dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Hasil Kuis',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: score >= 70 ? Colors.green.shade50 : Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                score >= 70 ? Icons.emoji_events : Icons.sentiment_dissatisfied,
                size: 60,
                color: score >= 70 ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 20),
            Text('Nilai Kamu', style: GoogleFonts.inter(color: textMuted)),
            Text(
              score.toStringAsFixed(1),
              style: GoogleFonts.inter(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: score >= 70 ? Colors.green : primaryColor,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Benar $correctAnswers dari ${questions.length} soal',
              style: GoogleFonts.inter(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context, {
                'score': score,
                'date': DateTime.now(),
              }); // Close Review Screen with result
            },
            child: Text(
              'Tutup',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine responsive width
    final bool isWide = MediaQuery.of(context).size.width > 600;
    final double contentWidth = isWide ? 600 : double.infinity;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: Text(
          'Review Jawaban',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Container(
          width: contentWidth,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Info Card
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
                child: Column(
                  children: [
                    _buildInfoRow(
                      'Di Mulai Pada',
                      'Kamis 25 Februari 2021 10:25',
                    ), // Mock date
                    _buildInfoRow('Status', 'Selesai'),
                    _buildInfoRow(
                      'Selesai Pada',
                      'Kamis 25 Februari 2021 10:40',
                    ), // Mock date
                    _buildInfoRow(
                      'Waktu Penyelesaian',
                      _formatDuration(timeTakenSeconds),
                    ),
                    _buildInfoRow('Nilai', '0 / 100'),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Questions List
              ...List.generate(questions.length, (index) {
                final question = questions[index];
                final selectedOptionIndex = selectedAnswers[index];
                final hasAnswer = selectedOptionIndex != null;
                final answerText = hasAnswer
                    ? 'A. ${question.options[selectedOptionIndex]}' // Assumption: Option A is index 0
                    : 'Belum dijawab';

                // Construct Answer Text more accurately (A, B, C...)
                String formattedAnswer = 'Belum dijawab';
                if (hasAnswer) {
                  final char = String.fromCharCode(65 + selectedOptionIndex);
                  formattedAnswer =
                      '$char. ${question.options[selectedOptionIndex]}';
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 100,
                            child: Text(
                              'Pertanyaan ${index + 1}',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: textMain,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                question.text,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: textMain,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: 100,
                          ), // Spacer to align with question box
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Jawaban Tersimpan',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: textMain,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  formattedAnswer,
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: textMain,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(
                                context,
                                index,
                              ); // Return question index to jump to
                            },
                            child: Text(
                              'Lihat Soal',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: const Color(
                                  0xFF4F46E5,
                                ), // Blueish link color
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 40),

              // Submit Button
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _submitFinal(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(
                        0xFF22C55E,
                      ), // Green color from design
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 48,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      'Kirim Jawaban',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: textMain,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: textMain,
            ),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }
}
