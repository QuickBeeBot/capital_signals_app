// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// class AuthPage extends StatefulWidget {
//   const AuthPage({Key? key}) : super(key: key);
//
//   @override
//   State<AuthPage> createState() => _AuthPageState();
// }
//
// class _AuthPageState extends State<AuthPage> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;
//   bool _isLogin = true;
//   bool _isLoading = false;
//   bool _obscurePassword = true;
//   bool _obscureConfirmPassword = true;
//
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//   final _nameController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
//     _animation = CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeInOut,
//     );
//     _controller.forward();
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     _nameController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _submitForm() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     setState(() => _isLoading = true);
//
//     try {
//       if (_isLogin) {
//         // Login
//         await FirebaseAuth.instance.signInWithEmailAndPassword(
//           email: _emailController.text.trim(),
//           password: _passwordController.text.trim(),
//         );
//
//         _showSuccessSnackbar('Logged in successfully!');
//       } else {
//         // Register
//         final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
//           email: _emailController.text.trim(),
//           password: _passwordController.text.trim(),
//         );
//
//         // Update display name if provided
//         if (_nameController.text.trim().isNotEmpty) {
//           await credential.user?.updateDisplayName(_nameController.text.trim());
//         }
//
//         _showSuccessSnackbar('Account created successfully!');
//       }
//
//       // Navigate to home after a brief delay
//       await Future.delayed(const Duration(milliseconds: 800));
//
//       if (mounted) {
//         Navigator.of(context).pushReplacementNamed('/home');
//       }
//     } on FirebaseAuthException catch (e) {
//       _showErrorDialog(_getErrorMessage(e));
//     } catch (e) {
//       _showErrorDialog('An unexpected error occurred. Please try again.');
//     } finally {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }
//
//   String _getErrorMessage(FirebaseAuthException e) {
//     switch (e.code) {
//       case 'email-already-in-use':
//         return 'This email is already registered. Please try logging in.';
//       case 'invalid-email':
//         return 'Please enter a valid email address.';
//       case 'operation-not-allowed':
//         return 'Email/password sign-in is not enabled. Please contact support.';
//       case 'weak-password':
//         return 'Password is too weak. Please use at least 6 characters.';
//       case 'user-disabled':
//         return 'This account has been disabled. Please contact support.';
//       case 'user-not-found':
//         return 'No account found with this email.';
//       case 'wrong-password':
//         return 'Incorrect password. Please try again.';
//       case 'too-many-requests':
//         return 'Too many attempts. Please try again later.';
//       default:
//         return e.message ?? 'An error occurred. Please try again.';
//     }
//   }
//
//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(
//           _isLogin ? 'Login Failed' : 'Sign Up Failed',
//           style: const TextStyle(color: Color(0xFFEF4444)),
//         ),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showSuccessSnackbar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: const Color(0xFF10B981),
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8),
//         ),
//       ),
//     );
//   }
//
//   void _toggleAuthMode() {
//     setState(() {
//       _isLogin = !_isLogin;
//       _controller.reset();
//       _controller.forward();
//     });
//   }
//
//   Future<void> _resetPassword() async {
//     final email = _emailController.text.trim();
//     if (email.isEmpty) {
//       _showErrorDialog('Please enter your email to reset password.');
//       return;
//     }
//
//     try {
//       await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
//       _showSuccessSnackbar('Password reset email sent! Check your inbox.');
//     } on FirebaseAuthException catch (e) {
//       _showErrorDialog(_getErrorMessage(e));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: AnimatedBuilder(
//         animation: _animation,
//         builder: (context, child) {
//           return FadeTransition(
//             opacity: _animation,
//             child: Transform.translate(
//               offset: Offset(0, (1 - _animation.value) * 50),
//               child: child,
//             ),
//           );
//         },
//         child: SafeArea(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(horizontal: 24),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 40),
//                 // Header with animation
//                 _buildHeader(),
//                 const SizedBox(height: 48),
//                 // Form
//                 _buildAuthForm(),
//                 const SizedBox(height: 32),
//                 // Action buttons
//                 _buildActionButtons(),
//                 const SizedBox(height: 24),
//                 // Divider
//                 _buildDivider(),
//                 const SizedBox(height: 24),
//                 // Toggle auth mode
//                 _buildToggleAuthMode(),
//                 const SizedBox(height: 40),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHeader() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           _isLogin ? 'Welcome Back!' : 'Create Account',
//           style: GoogleFonts.inter(
//             fontSize: 32,
//             fontWeight: FontWeight.w800,
//             color: const Color(0xFF1F2937),
//             letterSpacing: -0.5,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           _isLogin
//               ? 'Sign in to continue to your trading account'
//               : 'Start your trading journey with us',
//           style: const TextStyle(
//             fontSize: 16,
//             color: Color(0xFF6B7280),
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildAuthForm() {
//     return Form(
//       key: _formKey,
//       child: Column(
//         children: [
//           if (!_isLogin) ...[
//             // Name field (only for registration)
//             _buildTextField(
//               controller: _nameController,
//               label: 'Full Name',
//               hintText: 'John Doe',
//               icon: Icons.person_outline_rounded,
//               validator: (value) {
//                 if (value == null || value.trim().isEmpty) {
//                   return 'Please enter your name';
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(height: 20),
//           ],
//           // Email field
//           _buildTextField(
//             controller: _emailController,
//             label: 'Email Address',
//             hintText: 'you@example.com',
//             icon: Icons.email_outlined,
//             keyboardType: TextInputType.emailAddress,
//             validator: (value) {
//               if (value == null || value.trim().isEmpty) {
//                 return 'Please enter your email';
//               }
//               if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
//                 return 'Please enter a valid email';
//               }
//               return null;
//             },
//           ),
//           const SizedBox(height: 20),
//           // Password field
//           _buildTextField(
//             controller: _passwordController,
//             label: 'Password',
//             hintText: '••••••••',
//             icon: Icons.lock_outline_rounded,
//             obscureText: _obscurePassword,
//             suffixIcon: IconButton(
//               onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
//               icon: Icon(
//                 _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
//                 color: const Color(0xFF9CA3AF),
//               ),
//             ),
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Please enter your password';
//               }
//               if (value.length < 6) {
//                 return 'Password must be at least 6 characters';
//               }
//               return null;
//             },
//           ),
//           const SizedBox(height: 20),
//           // Confirm password (only for registration)
//           if (!_isLogin)
//             _buildTextField(
//               controller: _confirmPasswordController,
//               label: 'Confirm Password',
//               hintText: '••••••••',
//               icon: Icons.lock_reset_rounded,
//               obscureText: _obscureConfirmPassword,
//               suffixIcon: IconButton(
//                 onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
//                 icon: Icon(
//                   _obscureConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
//                   color: const Color(0xFF9CA3AF),
//                 ),
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please confirm your password';
//                 }
//                 if (value != _passwordController.text) {
//                   return 'Passwords do not match';
//                 }
//                 return null;
//               },
//             ),
//           if (_isLogin) ...[
//             const SizedBox(height: 20),
//             // Forgot password link
//             Align(
//               alignment: Alignment.centerRight,
//               child: TextButton(
//                 onPressed: _resetPassword,
//                 child: const Text(
//                   'Forgot Password?',
//                   style: TextStyle(
//                     color: Color(0xFF4F46E5),
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required String hintText,
//     required IconData icon,
//     bool obscureText = false,
//     Widget? suffixIcon,
//     TextInputType? keyboardType,
//     String? Function(String?)? validator,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//             color: Color(0xFF374151),
//             letterSpacing: 0.3,
//           ),
//         ),
//         const SizedBox(height: 8),
//         TextFormField(
//           controller: controller,
//           obscureText: obscureText,
//           keyboardType: keyboardType,
//           style: const TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w500,
//             color: Color(0xFF1F2937),
//           ),
//           decoration: InputDecoration(
//             hintText: hintText,
//             hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
//             prefixIcon: Container(
//               margin: const EdgeInsets.symmetric(horizontal: 12),
//               child: Icon(icon, color: const Color(0xFF6B7280), size: 22),
//             ),
//             suffixIcon: suffixIcon,
//             filled: true,
//             fillColor: const Color(0xFFF9FAFB),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1.5),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1.5),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: const BorderSide(color: Color(0xFF4F46E5), width: 2),
//             ),
//             errorBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
//             ),
//             contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//           ),
//           validator: validator,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildActionButtons() {
//     return Column(
//       children: [
//         // Main action button
//         SizedBox(
//           width: double.infinity,
//           height: 56,
//           child: ElevatedButton(
//             onPressed: _isLoading ? null : _submitForm,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFF4F46E5),
//               foregroundColor: Colors.white,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               elevation: 0,
//               shadowColor: Colors.transparent,
//             ),
//             child: _isLoading
//                 ? const SizedBox(
//               width: 24,
//               height: 24,
//               child: CircularProgressIndicator(
//                 strokeWidth: 2,
//                 color: Colors.white,
//               ),
//             )
//                 : Text(
//               _isLogin ? 'Sign In' : 'Create Account',
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(height: 16),
//         // Google Sign In (optional)
//         if (_isLogin)
//           SizedBox(
//             width: double.infinity,
//             height: 56,
//             child: OutlinedButton(
//               onPressed: _isLoading
//                   ? null
//                   : () {
//                 // Implement Google Sign In here if needed
//               },
//               style: OutlinedButton.styleFrom(
//                 side: const BorderSide(color: Color(0xFFE5E7EB), width: 1.5),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 foregroundColor: const Color(0xFF374151),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Image.asset(
//                     'assets/images/google.png',
//                     width: 24,
//                     height: 24,
//                   ),
//                   const SizedBox(width: 12),
//                   const Text(
//                     'Continue with Google',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//       ],
//     );
//   }
//
//   Widget _buildDivider() {
//     return Row(
//       children: [
//         Expanded(
//           child: Divider(
//             color: Colors.grey.shade300,
//             height: 1,
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: Text(
//             'Or continue with',
//             style: TextStyle(
//               color: Colors.grey.shade600,
//               fontSize: 14,
//             ),
//           ),
//         ),
//         Expanded(
//           child: Divider(
//             color: Colors.grey.shade300,
//             height: 1,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildToggleAuthMode() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text(
//           _isLogin ? "Don't have an account?" : 'Already have an account?',
//           style: const TextStyle(
//             color: Color(0xFF6B7280),
//             fontSize: 15,
//           ),
//         ),
//         const SizedBox(width: 4),
//         GestureDetector(
//           onTap: _toggleAuthMode,
//           child: Text(
//             _isLogin ? 'Sign Up' : 'Sign In',
//             style: const TextStyle(
//               color: Color(0xFF4F46E5),
//               fontSize: 15,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
//
//
//






import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  bool _isLogin = true;
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _authenticate() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      _errorMessage = null;

      try {
        if (_isLogin) {
          await _auth.signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
        } else {
          // Create user with email/password
          UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

          // Update display name if provided
          if (_nameController.text.trim().isNotEmpty) {
            await userCredential.user?.updateDisplayName(_nameController.text.trim());
          }
        }

        // Navigate to home screen after successful auth
        if (mounted) Navigator.of(context).pushReplacementNamed('/home');
      } on FirebaseAuthException catch (e) {
        setState(() {
          _errorMessage = _getErrorMessage(e);
        });
      } catch (e) {
        setState(() {
          _errorMessage = 'An unexpected error occurred. Please try again.';
        });
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Invalid email format';
      case 'user-not-found':
        return 'No account found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'email-already-in-use':
        return 'Email already registered';
      case 'weak-password':
        return 'Password must be at least 6 characters';
      case 'user-disabled':
        return 'This account has been disabled';
      default:
        return 'Authentication failed: ${e.message}';
    }
  }

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      _showError('Please enter a valid email address');
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: email);
      _showSuccess('Password reset link sent to your email');
    } catch (e) {
      _showError('Failed to send reset link. Please try again.');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade800,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green.shade800,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Color(0xFF121212) : Color(0xFFF8F9FC);
    final cardColor = isDarkMode ? Color(0xFF1E1E1E) : Colors.white;
    final inputColor = isDarkMode ? Color(0xFF2D2D2D) : Color(0xFFF1F3F5);
    final borderColor = isDarkMode ? Color(0xFF3A3A3A) : Color(0xFFE0E2E5);
    final textColor = isDarkMode ? Color(0xFFE8E8E8) : Color(0xFF2D3748);
    final secondaryColor = isDarkMode ? Color(0xFF888888) : Color(0xFF718096);
    final primaryGradient = isDarkMode
        ? [Color(0xFF6366F1), Color(0xFF8B5CF6)]
        : [Color(0xFF4361EE), Color(0xFF3A0CA3)];
    final logoGradient = isDarkMode
        ? [Color(0xFFFFFFFF), Color(0xFFFFFFFF)]
        : [Color(0xFFFFFFFF), Color(0xFFFFFFFF)];

    return Scaffold(
      resizeToAvoidBottomInset: true, // Critical for keyboard handling
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(), // Dismiss keyboard on background tap
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.only(
              top: 40,
              bottom: MediaQuery.of(context).viewInsets.bottom > 0 ? 24 : 40, // Extra padding when keyboard visible
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    // Logo section - fixed at top
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: logoGradient,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 12,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(36),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Image.asset(
                                  "assets/icon/app_logo.png",
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'CapitalSignals',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: textColor,
                              letterSpacing: -0.8,
                            ),
                          ),
                          Text(
                            _isLogin ? 'Welcome back to your trading dashboard' : 'Start your trading journey',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: secondaryColor,
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 32),

                    // Form card - scrollable content
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 24),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(isDarkMode ? 0.4 : 0.08),
                              blurRadius: 24,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(28.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Name field (signup only)
                                if (!_isLogin) ...[
                                  _buildInputField(
                                    controller: _nameController,
                                    label: 'Full Name',
                                    icon: Icons.person_outline,
                                    isDarkMode: isDarkMode,
                                    inputColor: inputColor,
                                    borderColor: borderColor,
                                    textColor: textColor,
                                    validator: (value) {
                                      if (value == null || value.trim().isEmpty) {
                                        return 'Please enter your name';
                                      }
                                      if (value.trim().length < 3) {
                                        return 'Name must be at least 3 characters';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 20),
                                ],

                                // Email field
                                _buildInputField(
                                  controller: _emailController,
                                  label: 'Email Address',
                                  icon: Icons.email_outlined,
                                  keyboardType: TextInputType.emailAddress,
                                  isDarkMode: isDarkMode,
                                  inputColor: inputColor,
                                  borderColor: borderColor,
                                  textColor: textColor,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Please enter your email';
                                    }
                                    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                                    if (!emailRegex.hasMatch(value.trim())) {
                                      return 'Please enter a valid email address';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 20),

                                // Password field
                                _buildInputField(
                                  controller: _passwordController,
                                  label: 'Password',
                                  icon: Icons.lock_outline,
                                  isPassword: true,
                                  obscureText: _obscurePassword,
                                  onToggleVisibility: () {
                                    setState(() => _obscurePassword = !_obscurePassword);
                                  },
                                  isDarkMode: isDarkMode,
                                  inputColor: inputColor,
                                  borderColor: borderColor,
                                  textColor: textColor,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Please enter your password';
                                    }
                                    if (value.trim().length < 6) {
                                      return 'Password must be at least 6 characters';
                                    }
                                    return null;
                                  },
                                ),

                                // Forgot password link (login mode only)
                                if (_isLogin) ...[
                                  SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: _resetPassword,
                                      child: Text(
                                        'Forgot password?',
                                        style: TextStyle(
                                          color: Color(0xFF4361EE),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],

                                // Error message
                                if (_errorMessage != null) ...[
                                  SizedBox(height: 16),
                                  Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFFFE8E8),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Color(0xFFFFB6B6), width: 1),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.error_outline, size: 18, color: Color(0xFFD32F2F)),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            _errorMessage!,
                                            style: TextStyle(
                                              color: Color(0xFFD32F2F),
                                              fontSize: 13,
                                              height: 1.4,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],

                                SizedBox(height: 24),

                                // Action button
                                _buildActionButton(
                                  onPressed: _isLoading ? null : _authenticate,
                                  text: _isLogin ? 'Sign In' : 'Create Account',
                                  isLoading: _isLoading,
                                  gradientColors: primaryGradient,
                                ),

                                SizedBox(height: 20),

                                // Divider with text
                                Row(
                                  children: [
                                    Expanded(
                                      child: Divider(
                                        thickness: 1,
                                        color: borderColor,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      child: Text(
                                        'or continue with',
                                        style: TextStyle(
                                          color: secondaryColor,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Divider(
                                        thickness: 1,
                                        color: borderColor,
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 20),

                                // Social login buttons (placeholders)
                                Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _buildSocialButton(
                                        icon: Icons.g_mobiledata,
                                        color: Color(0xFFDB4437),
                                        onPressed: () => _showComingSoon('Google'),
                                      ),
                                      SizedBox(width: 16),
                                      _buildSocialButton(
                                        icon: Icons.facebook,
                                        color: Color(0xFF1877F2),
                                        onPressed: () => _showComingSoon('Facebook'),
                                      ),
                                      SizedBox(width: 16),
                                      _buildSocialButton(
                                        icon: Icons.apple,
                                        color: Colors.black,
                                        onPressed: () => _showComingSoon('Apple'),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: 24),

                                // Switch mode link
                                Center(
                                  child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _isLogin = !_isLogin;
                                        _errorMessage = null;
                                        _nameController.clear();
                                        _emailController.clear();
                                        _passwordController.clear();
                                        _obscurePassword = true;
                                      });
                                      FocusScope.of(context).unfocus();
                                    },
                                    child: RichText(
                                      text: TextSpan(
                                        text: _isLogin ? "Don't have an account? " : 'Already have an account? ',
                                        style: TextStyle(
                                          color: secondaryColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: _isLogin ? 'Sign Up' : 'Sign In',
                                            style: TextStyle(
                                              color: Color(0xFF4361EE),
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                // Footer spacer to prevent content cutoff when keyboard appears
                                SizedBox(height: 16),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Footer copyright - stays at bottom but scrolls with content
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 16),
                      child: Text(
                        '© ${DateTime.now().year} CapitalSignals. All rights reserved.',
                        style: TextStyle(
                          color: secondaryColor.withOpacity(0.7),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = true,
    VoidCallback? onToggleVisibility,
    TextInputType keyboardType = TextInputType.text,
    required bool isDarkMode,
    required Color inputColor,
    required Color borderColor,
    required Color textColor,
    required FormFieldValidator<String> validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            height: 1.3,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: inputColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: borderColor,
              width: 1.2,
            ),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: isPassword ? obscureText : false,
            decoration: InputDecoration(
              hintText: 'Enter your ${label.toLowerCase()}',
              hintStyle: TextStyle(
                color: isDarkMode ? Color(0xFF666666) : Color(0xFFA0AEC0),
                fontSize: 14,
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Icon(icon, size: 20, color: isDarkMode ? Color(0xFF888888) : Color(0xFFA0AEC0)),
              ),
              suffixIcon: isPassword
                  ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  size: 20,
                  color: isDarkMode ? Color(0xFF888888) : Color(0xFFA0AEC0),
                ),
                onPressed: onToggleVisibility,
                splashRadius: 20,
              )
                  : null,
              contentPadding: EdgeInsets.only(left: 12, bottom: 14, top: 14),
              border: InputBorder.none,
            ),
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            validator: validator,
            onFieldSubmitted: (_) {
              if (_isLogin) {
                _authenticate();
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required VoidCallback? onPressed,
    required String text,
    required bool isLoading,
    required List<Color> gradientColors,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: gradientColors[0].withOpacity(0.4),
              blurRadius: 16,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(16),
            child: Center(
              child: isLoading
                  ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 2.5,
              )
                  : Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(24),
          child: Icon(icon, size: 24, color: color),
        ),
      ),
    );
  }

  void _showComingSoon(String provider) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$provider login coming soon!'),
        backgroundColor: Colors.blueGrey.shade800,
        duration: Duration(seconds: 2),
      ),
    );
  }
}




