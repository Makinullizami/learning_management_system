import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import 'login_screen.dart';

// Brand colors from the HTML design
class AppColors {
  static const Color brandLighter = Color(0xFFE06868);
  static const Color brandDefault = Color(0xFFBD4A4A);
  static const Color brandDarker = Color(0xFF943636);
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _pulseController;
  late AnimationController _spinController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Set status bar to transparent
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    // Fade in up animation
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutCubic,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
          CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic),
        );

    // Pulse animation for glow effect
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Spin animation for loading indicator
    _spinController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();

    // Start animations
    _fadeController.forward();
    _pulseController.repeat(reverse: true);

    // Navigate to login screen after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const LoginScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _pulseController.dispose();
    _spinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate responsive sizes
          final screenWidth = constraints.maxWidth;
          final screenHeight = constraints.maxHeight;
          final isSmallScreen = screenHeight < 600;

          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.brandLighter,
                  AppColors.brandDefault,
                  AppColors.brandDarker,
                ],
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background decorative elements
                _buildBackgroundEffects(screenWidth, screenHeight),

                // Main content - centered
                SafeArea(
                  child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Spacer to push content to center
                        const Spacer(flex: 2),

                        // Main content area - centered
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: _buildMainContent(isSmallScreen),
                          ),
                        ),

                        // Spacer between main content and spinner
                        const Spacer(flex: 2),

                        // Loading spinner at bottom - centered
                        Center(
                          child: Padding(
                            padding: EdgeInsets.only(
                              bottom: isSmallScreen ? 40 : 80,
                            ),
                            child: Opacity(
                              opacity: 0.7,
                              child: _buildLoadingSpinner(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBackgroundEffects(double screenWidth, double screenHeight) {
    return Stack(
      children: [
        // Top-left glow
        Positioned(
          top: -screenHeight * 0.2,
          left: -screenWidth * 0.1,
          child: Container(
            width: screenWidth * 1.2,
            height: screenWidth * 1.2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.1),
                  blurRadius: 120,
                  spreadRadius: 50,
                ),
              ],
            ),
          ),
        ),
        // Right-side dark overlay
        Positioned(
          top: screenHeight * 0.4,
          right: -screenWidth * 0.2,
          child: Container(
            width: screenWidth,
            height: screenWidth,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 100,
                  spreadRadius: 30,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMainContent(bool isSmallScreen) {
    final logoSize = isSmallScreen ? 72.0 : 96.0;
    final titleSize = isSmallScreen ? 48.0 : 60.0;
    final subtitleSize = isSmallScreen ? 10.0 : 12.0;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo with pulse effect - centered
            Center(
              child: AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Container(
                    width: logoSize,
                    height: logoSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withValues(
                            alpha: 0.2 * _pulseAnimation.value,
                          ),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: CustomPaint(
                      size: Size(logoSize, logoSize),
                      painter: CeloLogoPainter(),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: isSmallScreen ? 16 : 24),

            // CELOE Title - centered
            Center(
              child: Text(
                'CELOE',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: titleSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -2,
                  height: 1,
                  shadows: const [
                    Shadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: isSmallScreen ? 24 : 40),

            // Divider line - centered
            Center(
              child: Container(
                width: 32,
                height: 2,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ),

            SizedBox(height: isSmallScreen ? 8 : 12),

            // Subtitle - centered
            Center(
              child: Text(
                'LEARNING MANAGEMENT SYSTEM',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: subtitleSize,
                  fontWeight: FontWeight.w300,
                  color: Colors.white.withValues(alpha: 0.8),
                  letterSpacing: 3,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingSpinner() {
    return AnimatedBuilder(
      animation: _spinController,
      builder: (context, child) {
        return Transform.rotate(
          angle: _spinController.value * 2 * math.pi,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: 8,
                height: 2,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Custom painter for the CELOE logo
class CeloLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;

    // Outer circle (faded)
    final outerCirclePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius, outerCirclePaint);

    // Arc (main design element)
    final arcPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;

    final arcRect = Rect.fromCircle(center: center, radius: radius);
    // Draw arc from bottom-left going around to the right
    canvas.drawArc(
      arcRect,
      -math.pi * 0.65, // Start angle
      math.pi * 1.55, // Sweep angle
      false,
      arcPaint,
    );

    // Center dot
    final centerDotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 6, centerDotPaint);

    // Small dot at the end of the arc
    final endAngle = -math.pi * 0.65 + math.pi * 1.55;
    final endDotX = center.dx + radius * math.cos(endAngle);
    final endDotY = center.dy + radius * math.sin(endAngle);
    canvas.drawCircle(Offset(endDotX, endDotY), 4, centerDotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
