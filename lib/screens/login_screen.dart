import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isDarkMode = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Colors based on HTML design
  Color get primaryColor => const Color(0xFFB92B2B);
  Color get primaryDark => const Color(0xFF991B1B);
  Color get backgroundColor =>
      _isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
  Color get surfaceColor =>
      _isDarkMode ? const Color(0xFF1E293B) : Colors.white;
  Color get inputBgColor =>
      _isDarkMode ? const Color(0xFF334155) : const Color(0xFFF1F5F9);
  Color get textMainColor =>
      _isDarkMode ? const Color(0xFFF8FAFC) : const Color(0xFF1E293B);
  Color get textMutedColor =>
      _isDarkMode ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenHeight = constraints.maxHeight;
          final screenWidth = constraints.maxWidth;
          final isSmallScreen = screenHeight < 700;

          return Stack(
            children: [
              // Background with header
              SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    children: [
                      // Header section with curve
                      _buildHeader(screenHeight, screenWidth, isSmallScreen),

                      // Spacer for card overlap
                      SizedBox(height: isSmallScreen ? 120 : 140),

                      // Bottom section
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),

              // Login Card - positioned to overlap header
              Positioned(
                top: screenHeight * (isSmallScreen ? 0.28 : 0.32),
                left: 0,
                right: 0,
                child: Center(child: _buildLoginCard(isSmallScreen)),
              ),

              // Dark mode toggle button
              Positioned(
                top: MediaQuery.of(context).padding.top + 16,
                right: 16,
                child: _buildDarkModeToggle(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(
    double screenHeight,
    double screenWidth,
    bool isSmallScreen,
  ) {
    return Container(
      height: screenHeight * (isSmallScreen ? 0.38 : 0.42),
      width: double.infinity,
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(48),
          bottomRight: Radius.circular(48),
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
                bottomLeft: Radius.circular(48),
                bottomRight: Radius.circular(48),
              ),
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  primaryColor,
                  const Color(0xFF991B1B),
                  const Color(0xFF7C2D12),
                ],
              ),
            ),
          ),

          // Decorative circles
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
          ),
          Positioned(
            bottom: 60,
            left: -20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),

          // Content
          Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: isSmallScreen ? 40 : 60),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon container
                  Container(
                    width: isSmallScreen ? 64 : 80,
                    height: isSmallScreen ? 64 : 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
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
                    child: Transform.rotate(
                      angle: 0.05,
                      child: Icon(
                        Icons.local_library,
                        size: isSmallScreen ? 36 : 44,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  SizedBox(height: isSmallScreen ? 16 : 20),

                  // Title
                  Text(
                    'LMS Portal',
                    style: GoogleFonts.inter(
                      fontSize: isSmallScreen ? 26 : 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: -0.5,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginCard(bool isSmallScreen) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 380),
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: EdgeInsets.all(isSmallScreen ? 24 : 32),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: _isDarkMode
              ? Colors.grey.shade700
              : Colors.white.withValues(alpha: 0.6),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Welcome text
          Text(
            'Welcome Back',
            style: GoogleFonts.inter(
              fontSize: isSmallScreen ? 22 : 24,
              fontWeight: FontWeight.bold,
              color: textMainColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please log in to continue',
            style: GoogleFonts.inter(fontSize: 14, color: textMutedColor),
          ),

          SizedBox(height: isSmallScreen ? 24 : 32),

          // Email field
          _buildInputField(
            label: 'EMAIL',
            hint: 'student@example.com',
            icon: Icons.mail_outline,
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
          ),

          SizedBox(height: isSmallScreen ? 16 : 20),

          // Password field
          _buildPasswordField(),

          const SizedBox(height: 16),

          // Remember me & Forgot password
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Remember me
              GestureDetector(
                onTap: () => setState(() => _rememberMe = !_rememberMe),
                child: Row(
                  children: [
                    SizedBox(
                      width: 18,
                      height: 18,
                      child: Checkbox(
                        value: _rememberMe,
                        onChanged: (value) =>
                            setState(() => _rememberMe = value!),
                        activeColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        side: BorderSide(color: Colors.grey.shade400),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Remember me',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: textMutedColor,
                      ),
                    ),
                  ],
                ),
              ),

              // Forgot password
              GestureDetector(
                onTap: () {
                  // TODO: Navigate to forgot password
                },
                child: Text(
                  'Forgot Password?',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: isSmallScreen ? 20 : 24),

          // Login button
          _buildLoginButton(),

          SizedBox(height: isSmallScreen ? 24 : 32),

          // Divider
          Container(
            height: 1,
            color: _isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200,
          ),

          SizedBox(height: isSmallScreen ? 20 : 24),

          // Sign up link
          RichText(
            text: TextSpan(
              style: GoogleFonts.inter(fontSize: 12, color: textMutedColor),
              children: [
                const TextSpan(text: "Don't have an account? "),
                WidgetSpan(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Sign Up',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Need help
          GestureDetector(
            onTap: () {
              // TODO: Show help dialog
            },
            child: Text(
              'Need Help?',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: textMutedColor,
                decoration: TextDecoration.underline,
                decorationStyle: TextDecorationStyle.dotted,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: textMutedColor,
              letterSpacing: 1.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: inputBgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.transparent),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: GoogleFonts.inter(fontSize: 14, color: textMainColor),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey.shade400,
              ),
              prefixIcon: Icon(icon, color: Colors.grey.shade400, size: 22),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: primaryColor.withValues(alpha: 0.5),
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            'PASSWORD',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: textMutedColor,
              letterSpacing: 1.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: inputBgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            style: GoogleFonts.inter(fontSize: 14, color: textMainColor),
            decoration: InputDecoration(
              hintText: '••••••••',
              hintStyle: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey.shade400,
              ),
              prefixIcon: Icon(
                Icons.lock_outline,
                color: Colors.grey.shade400,
                size: 22,
              ),
              suffixIcon: IconButton(
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey.shade400,
                  size: 20,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: primaryColor.withValues(alpha: 0.5),
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // TODO: Handle login
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          shadowColor: primaryColor.withValues(alpha: 0.4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Log In',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward, size: 18),
          ],
        ),
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
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
