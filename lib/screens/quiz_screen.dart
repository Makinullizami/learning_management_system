import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'quiz_answer_review_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  // Colors from design
  static const Color primaryColor = Color(0xFFC54E4E);
  static const Color backgroundColor = Color(0xFFFAFAFA);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color textMain = Color(0xFF1F2937);
  static const Color textMuted = Color(0xFF6B7280);

  // State variables
  int _currentQuestionIndex = 0;
  final Map<int, int> _selectedAnswers = {}; // Question Index -> Option Index
  Timer? _timer;
  int _timeLeftSeconds = 15 * 60; // 15 minutes

  // Mock Data
  // Mock Data
  final List<QuizQuestion> _questions = [
    QuizQuestion(
      id: 1,
      text: 'Apa kepanjangan dari UX dalam bidang desain?',
      options: [
        'User Extension',
        'User Experience',
        'User Example',
        'Unit Experience',
      ],
      correctOptionIndex: 1, // B
    ),
    QuizQuestion(
      id: 2,
      text: 'Apa fokus utama dari User Interface (UI) Design?',
      options: [
        'Kecepatan loading website',
        'Alur logika aplikasi dari awal hingga akhir',
        'Tampilan visual, estetika, dan interaksi elemen pada layar',
        'Riset perilaku pengguna di lapangan',
      ],
      correctOptionIndex: 2, // C
    ),
    QuizQuestion(
      id: 3,
      text:
          'Manakah tahapan pertama yang biasanya dilakukan dalam proses Design Thinking?',
      options: ['Ideate', 'Prototype', 'Define', 'Empathize'],
      correctOptionIndex: 3, // D
    ),
    QuizQuestion(
      id: 4,
      text: 'Apa yang dimaksud dengan "Wireframe" dalam desain UI/UX?',
      options: [
        'Desain akhir dengan warna dan gambar yang lengkap',
        'Kerangka dasar atau blueprint hitam-putih yang menunjukkan tata letak elemen',
        'Proses pengkodean aplikasi menggunakan HTML/CSS',
        'Hasil pengujian pengguna terhadap produk',
      ],
      correctOptionIndex: 1, // B
    ),
    QuizQuestion(
      id: 5,
      text:
          '"Usability" adalah atribut kualitas yang menilai seberapa mudah antarmuka pengguna digunakan. Siapa tokoh yang dikenal sebagai bapak Usability?',
      options: ['Steve Jobs', 'Jakob Nielsen', 'Elon Musk', 'Bill Gates'],
      correctOptionIndex: 1, // B
    ),
    QuizQuestion(
      id: 6,
      text: 'Apa tujuan utama dari pembuatan "User Persona"?',
      options: [
        'Menentukan harga jual aplikasi',
        'Memilih kombinasi warna yang sedang tren',
        'Representasi karakter fiktif yang mewakili target pengguna produk',
        'Membuat struktur database aplikasi',
      ],
      correctOptionIndex: 2, // C
    ),
    QuizQuestion(
      id: 7,
      text:
          'Prinsip desain yang memberikan petunjuk visual tentang bagaimana suatu objek harus digunakan disebut...',
      options: ['Feedback', 'Constraints', 'Affordance', 'Mapping'],
      correctOptionIndex: 2, // C
    ),
    QuizQuestion(
      id: 8,
      text: 'Apa perbedaan utama antara UI dan UX?',
      options: [
        'UI adalah tentang cara kerja, UX adalah tentang tampilan',
        'UI adalah bagian dari UX yang fokus pada visual, UX mencakup keseluruhan pengalaman pengguna',
        'UI hanya untuk aplikasi mobile, UX hanya untuk website',
        'Tidak ada perbedaan, keduanya adalah hal yang sama',
      ],
      correctOptionIndex: 1, // B
    ),
    QuizQuestion(
      id: 9,
      text:
          'Istilah untuk urutan langkah-langkah yang diambil pengguna dalam aplikasi untuk menyelesaikan tugas tertentu adalah...',
      options: ['User Flow', 'Color Palette', 'Typography', 'Moodboard'],
      correctOptionIndex: 0, // A
    ),
    QuizQuestion(
      id: 10,
      text:
          'Dalam teori warna, warna yang berseberangan di roda warna disebut warna...',
      options: ['Analog', 'Monokromatik', 'Komplementer', 'Triadik'],
      correctOptionIndex: 2, // C
    ),
    QuizQuestion(
      id: 11,
      text: 'Apa fungsi dari "High-Fidelity Prototype"?',
      options: [
        'Memberikan gambaran kasar ide dengan coretan kertas',
        'Simulasi produk yang sangat mendekati produk asli (interaktif dan detail)',
        'Alat untuk menulis kode backend',
        'Dokumen kontrak antara desainer dan klien',
      ],
      correctOptionIndex: 1, // B
    ),
    QuizQuestion(
      id: 12,
      text:
          'Metode riset UX yang melibatkan pengamatan langsung saat pengguna menggunakan produk disebut...',
      options: [
        'A/B Testing',
        'Usability Testing',
        'Survey Online',
        'Focus Group Discussion (FGD)',
      ],
      correctOptionIndex: 1, // B
    ),
    QuizQuestion(
      id: 13,
      text: 'Apa yang dimaksud dengan "White Space" dalam UI Design?',
      options: [
        'Ruang kosong di antara elemen desain untuk memberikan "napas" pada konten',
        'Area yang harus diisi dengan iklan',
        'Kesalahan desain karena gambar tidak muncul',
        'Latar belakang yang harus selalu berwarna putih',
      ],
      correctOptionIndex: 0, // A
    ),
    QuizQuestion(
      id: 14,
      text: 'Hukum Fitts (Fitts\'s Law) dalam UI UX berkaitan dengan...',
      options: [
        'Penggunaan warna yang kontras',
        'Waktu yang dibutuhkan untuk berpindah ke target berdasarkan jarak dan ukuran target',
        'Jumlah maksimal menu yang bisa diingat manusia',
        'Cara membaca pengguna dari kiri ke kanan',
      ],
      correctOptionIndex: 1, // B
    ),
    QuizQuestion(
      id: 15,
      text: '"Information Architecture" (IA) berfokus pada...',
      options: [
        'Keamanan data pengguna',
        'Pengorganisasian dan penstrukturan informasi agar mudah ditemukan',
        'Pembuatan logo perusahaan',
        'Kecepatan server aplikasi',
      ],
      correctOptionIndex: 1, // B
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeftSeconds > 0) {
        if (mounted) {
          setState(() {
            _timeLeftSeconds--;
          });
        }
      } else {
        _timer?.cancel();
        // Handle timeout
      }
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _onOptionSelected(int optionIndex) {
    setState(() {
      _selectedAnswers[_currentQuestionIndex] = optionIndex;
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      _goToReview();
    }
  }

  void _goToReview() async {
    // 15 minutes in seconds = 900
    final int timeTaken = (15 * 60) - _timeLeftSeconds;

    // Navigate to Review Screen
    // We expect it might return an index to jump to
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizAnswerReviewScreen(
          questions: _questions,
          selectedAnswers: _selectedAnswers,
          timeTakenSeconds: timeTaken,
        ),
      ),
    );

    // If result is an int, it means user clicked "Lihat Soal"
    if (result is int) {
      _jumpToQuestion(result);
    } else if (result is Map) {
      // Quiz submitted, pass result back
      if (mounted) {
        Navigator.pop(context, result);
      }
    }
  }

  void _jumpToQuestion(int index) {
    setState(() {
      _currentQuestionIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Determine responsive width
    final bool isWide = MediaQuery.of(context).size.width > 600;
    final double contentWidth = isWide ? 600 : double.infinity;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          Column(
            children: [
              // Header
              _buildHeader(),

              Expanded(
                child: Center(
                  child: Container(
                    width: contentWidth,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 24),

                          // Question Navigator
                          _buildQuestionNavigator(),

                          const SizedBox(height: 24),

                          // Question Card
                          _buildQuestionContent(),

                          const SizedBox(height: 32),

                          // Navigation Button
                          _buildNextButton(),

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        bottom: 24,
        left: 24,
        right: 24,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Quiz Review 1',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.timer_outlined,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _formatTime(_timeLeftSeconds),
                      style: GoogleFonts.robotoMono(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionNavigator() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 8,
        runSpacing: 8,
        children: List.generate(_questions.length, (index) {
          final bool isCurrent = index == _currentQuestionIndex;
          final bool isAnswered = _selectedAnswers.containsKey(index);

          return GestureDetector(
            onTap: () => _jumpToQuestion(index),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isCurrent
                    ? primaryColor
                    : isAnswered
                    ? primaryColor.withOpacity(0.1)
                    : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCurrent
                      ? primaryColor
                      : isAnswered
                      ? primaryColor
                      : Colors.grey.shade300,
                  width: isCurrent ? 2 : 1,
                ),
                boxShadow: isCurrent
                    ? [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: isCurrent || isAnswered
                        ? FontWeight.w600
                        : FontWeight.w500,
                    color: isCurrent
                        ? Colors.white
                        : isAnswered
                        ? primaryColor
                        : Colors.grey.shade600,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildQuestionContent() {
    final question = _questions[_currentQuestionIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Question Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Soal Nomor',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textMain,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${_currentQuestionIndex + 1}',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                  height: 1.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4, left: 4),
                child: Text(
                  '/ ${_questions.length}',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: textMuted,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        Text(
          question.text,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: textMain,
            height: 1.5,
          ),
        ),

        const SizedBox(height: 24),

        // Options
        ...List.generate(question.options.length, (index) {
          final optionChar = String.fromCharCode(65 + index); // A, B, C...
          final isSelected = _selectedAnswers[_currentQuestionIndex] == index;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: () => _onOptionSelected(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected ? primaryColor : backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? primaryColor : Colors.transparent,
                    width: isSelected ? 2 : 0,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [
                          const BoxShadow(
                            color: Colors.black12,
                            blurRadius: 1,
                            offset: Offset(0, 1),
                          ),
                        ],
                ),
                child: Row(
                  children: [
                    // Option Letter Circle
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white.withOpacity(0.2)
                            : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? Colors.white.withOpacity(0.3)
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          optionChar,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? Colors.white
                                : Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        question.options[index],
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? Colors.white : textMain,
                        ),
                      ),
                    ),
                    if (isSelected)
                      const Icon(
                        Icons.check_circle_rounded,
                        color: Colors.white,
                      ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildNextButton() {
    final isLastQuestion = _currentQuestionIndex == _questions.length - 1;

    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: _nextQuestion,
        style: ElevatedButton.styleFrom(
          backgroundColor: isLastQuestion ? Colors.green : Colors.grey.shade100,
          foregroundColor: isLastQuestion ? Colors.white : textMain,
          elevation: isLastQuestion ? 2 : 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isLastQuestion ? 'Selesai Kuis' : 'Soal Selanjutnya',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              isLastQuestion ? Icons.check : Icons.arrow_forward_ios_rounded,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class QuizQuestion {
  final int id;
  final String text;
  final List<String> options;
  final int correctOptionIndex;

  QuizQuestion({
    required this.id,
    required this.text,
    required this.options,
    required this.correctOptionIndex,
  });
}
