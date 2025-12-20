import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isDarkMode = false;
  bool _isLoading = false;
  // Focus nodes for floating label effect
  final _fullNameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _fullNameFocus.addListener(() => setState(() {}));
    _emailFocus.addListener(() => setState(() {}));
    _passwordFocus.addListener(() => setState(() {}));
    _confirmPasswordFocus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullNameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  // Colors based on HTML design
  Color get primaryColor => const Color(0xFFB92B27);
  Color get primaryDark => const Color(0xFF991B1B);
  Color get backgroundColor =>
      _isDarkMode ? const Color(0xFF121212) : const Color(0xFFF3F4F6);
  Color get cardColor => _isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
  Color get fieldBgColor =>
      _isDarkMode ? const Color(0xFF27272A) : const Color(0xFFF9FAFB);
  Color get textColor =>
      _isDarkMode ? const Color(0xFFF3F4F6) : const Color(0xFF1F2937);
  Color get textMutedColor => const Color(0xFF9CA3AF);
  Color get borderColor =>
      _isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // Main scrollable content
          SingleChildScrollView(
            child: Column(
              children: [
                // Header section
                _buildHeader(false),

                // Sign Up Card - overlapping header
                Transform.translate(
                  offset: const Offset(0, -50),
                  child: _buildSignUpCard(false),
                ),

                // Bottom spacing
                const SizedBox(height: 24),
              ],
            ),
          ),

          // Back button (fixed position)
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 16,
            child: _buildBackButton(),
          ),

          // Dark mode toggle (fixed position)
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            right: 16,
            child: _buildDarkModeToggle(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isSmallScreen) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Container(
      height: 320 + topPadding,
      width: double.infinity,
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [primaryColor, primaryColor, primaryDark],
              ),
            ),
          ),

          // Pattern overlay (simulated with dots)
          Positioned.fill(child: CustomPaint(painter: PatternPainter())),

          // Decorative blur circles
          Positioned(
            top: -40,
            right: -40,
            child: Container(
              width: 256,
              height: 256,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: -40,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.yellow.withValues(alpha: 0.1),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon container with rotation
                    Transform.rotate(
                      angle: 0.05,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.school,
                          size: 48,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Title
                    Text(
                      'Create Account',
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Subtitle
                    Text(
                      'Start your learning journey today',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpCard(bool isSmallScreen) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 400),
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: EdgeInsets.all(isSmallScreen ? 24 : 32),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: _isDarkMode
              ? Colors.grey.shade800
              : Colors.white.withValues(alpha: 0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Full Name field
          _buildFloatingLabelField(
            controller: _fullNameController,
            focusNode: _fullNameFocus,
            label: 'Full Name',
            icon: Icons.person_outline,
            keyboardType: TextInputType.name,
          ),

          const SizedBox(height: 20),

          // Email field
          _buildFloatingLabelField(
            controller: _emailController,
            focusNode: _emailFocus,
            label: 'Email Address',
            icon: Icons.mail_outline,
            keyboardType: TextInputType.emailAddress,
          ),

          const SizedBox(height: 20),

          // Password field
          _buildPasswordField(
            controller: _passwordController,
            focusNode: _passwordFocus,
            label: 'Password',
            icon: Icons.lock_outline,
            obscure: _obscurePassword,
            onToggle: () =>
                setState(() => _obscurePassword = !_obscurePassword),
          ),

          const SizedBox(height: 20),

          // Confirm Password field
          _buildPasswordField(
            controller: _confirmPasswordController,
            focusNode: _confirmPasswordFocus,
            label: 'Confirm Password',
            icon: Icons.verified_user_outlined,
            obscure: _obscureConfirmPassword,
            onToggle: () => setState(
              () => _obscureConfirmPassword = !_obscureConfirmPassword,
            ),
          ),

          const SizedBox(height: 28),

          // Sign Up button
          _buildSignUpButton(),

          const SizedBox(height: 24),

          // Login link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already have an account? ',
                style: GoogleFonts.poppins(fontSize: 14, color: textMutedColor),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Text(
                  'Login',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingLabelField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final bool hasValue = controller.text.isNotEmpty;
    final bool hasFocus = focusNode.hasFocus;
    final bool isFloating = hasValue || hasFocus;

    return Container(
      decoration: BoxDecoration(
        color: fieldBgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasFocus ? primaryColor : borderColor,
          width: hasFocus ? 2 : 1,
        ),
      ),
      child: Stack(
        children: [
          TextField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: keyboardType,
            onChanged: (value) => setState(() {}),
            style: GoogleFonts.poppins(fontSize: 14, color: textColor),
            decoration: InputDecoration(
              prefixIcon: Icon(
                icon,
                color: hasFocus ? primaryColor : textMutedColor,
                size: 22,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 18,
              ),
            ),
          ),
          // Floating label
          Positioned(
            left: 48,
            top: isFloating ? 4 : 16,
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: GoogleFonts.poppins(
                fontSize: isFloating ? 10 : 14,
                color: hasFocus ? primaryColor : textMutedColor,
              ),
              child: Text(label),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required IconData icon,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    final bool hasValue = controller.text.isNotEmpty;
    final bool hasFocus = focusNode.hasFocus;
    final bool isFloating = hasValue || hasFocus;

    return Container(
      decoration: BoxDecoration(
        color: fieldBgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasFocus ? primaryColor : borderColor,
          width: hasFocus ? 2 : 1,
        ),
      ),
      child: Stack(
        children: [
          TextField(
            controller: controller,
            focusNode: focusNode,
            obscureText: obscure,
            onChanged: (value) => setState(() {}),
            style: GoogleFonts.poppins(fontSize: 14, color: textColor),
            decoration: InputDecoration(
              prefixIcon: Icon(
                icon,
                color: hasFocus ? primaryColor : textMutedColor,
                size: 22,
              ),
              suffixIcon: IconButton(
                onPressed: onToggle,
                icon: Icon(
                  obscure ? Icons.visibility_off : Icons.visibility,
                  color: textMutedColor,
                  size: 20,
                ),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 18,
              ),
            ),
          ),
          // Floating label
          Positioned(
            left: 48,
            top: isFloating ? 4 : 16,
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: GoogleFonts.poppins(
                fontSize: isFloating ? 10 : 14,
                color: hasFocus ? primaryColor : textMutedColor,
              ),
              child: Text(label),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleSignUp,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          shadowColor: primaryColor.withValues(alpha: 0.4),
        ),
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Sign Up',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, size: 18),
                ],
              ),
      ),
    );
  }

  Future<void> _handleSignUp() async {
    final fullName = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (fullName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showMessage('Please fill in all fields');
      return;
    }

    if (password != confirmPassword) {
      _showMessage('Passwords do not match');
      return;
    }

    if (password.length < 6) {
      _showMessage('Password must be at least 6 characters');
      return;
    }

    setState(() => _isLoading = true);

    final success = await AuthService.register(fullName, email, password);

    setState(() => _isLoading = false);

    if (success && mounted) {
      _showMessage('Account created successfully! Please login.');
      Navigator.of(context).pop();
    } else {
      _showMessage('Email already registered');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildBackButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
      ),
    );
  }

  Widget _buildDarkModeToggle() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: IconButton(
        onPressed: () => setState(() => _isDarkMode = !_isDarkMode),
        icon: Icon(
          _isDarkMode ? Icons.light_mode : Icons.dark_mode,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}

// Custom painter for cross pattern background
class PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..style = PaintingStyle.fill;

    const spacing = 60.0;
    const crossSize = 8.0;
    const crossWidth = 2.0;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        // Horizontal line of cross
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset(x, y),
            width: crossSize,
            height: crossWidth,
          ),
          paint,
        );
        // Vertical line of cross
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset(x, y),
            width: crossWidth,
            height: crossSize,
          ),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
