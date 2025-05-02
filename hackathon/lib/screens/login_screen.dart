import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/farmer_provider.dart';
import '../widgets/custom_button.dart';
import 'farmer_home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _showPassword = false;
  String _selectedRole = 'farmer';  // Default role is 'farmer'

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final farmerProvider = context.watch<FarmerProvider>();

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/registration_bg.jpg'), // Same background
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Dark overlay
          Container(color: Colors.black.withOpacity(0.5)),

          // Centered Login Form
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: Colors.white.withOpacity(0.95),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildTextFormField(
                          controller: _emailCtrl,
                          label: 'Email Address',
                          icon: Icons.email,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || !value.contains('@')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildTextFormField(
                          controller: _passwordCtrl,
                          label: 'Password',
                          icon: Icons.lock,
                          obscureText: !_showPassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _showPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.green,
                            ),
                            onPressed: () {
                              setState(() {
                                _showPassword = !_showPassword;
                              });
                            },
                          ),
                          validator: (value) {
                            if (value == null || value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        // Dropdown for selecting role (farmer or admin)
                        DropdownButtonFormField<String>(
                          value: _selectedRole,
                          onChanged: (val) {
                            setState(() {
                              _selectedRole = val!;
                            });
                          },
                          items: ['farmer', 'admin']
                              .map(
                                (role) => DropdownMenuItem(
                                  value: role,
                                  child: Text(role.toUpperCase()),
                                ),
                              )
                              .toList(),
                          decoration: const InputDecoration(
                            labelText: 'Select Role',
                            prefixIcon: Icon(Icons.account_circle, color: Colors.green),
                          ),
                        ),
                        const SizedBox(height: 24),
                        farmerProvider.isLoading
                            ? const CircularProgressIndicator()
                            : CustomButton(
                                text: 'Login',
                                onPressed: () async {
                                  if (!_formKey.currentState!.validate()) return;

                                  final email = _emailCtrl.text.trim();
                                  final password = _passwordCtrl.text.trim();

                                  // Pass the selected role along with email and password
                                  final success = await authProvider.login(
                                      email, password, _selectedRole);

                                  if (success && context.mounted) {
                                    // Navigate to Farmer Home Screen based on the selected role
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const FarmerHomeScreen(),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Invalid credentials')),
                                    );
                                  }
                                },
                              ),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          child: const Text(
                            "Don't have an account? Register",
                            style: TextStyle(color: Colors.green, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
    FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.green),
        suffixIcon: suffixIcon,
        labelStyle: const TextStyle(color: Colors.green),
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
        ),
      ),
    );
  }
}
