import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/farmer_provider.dart';
import '../widgets/custom_input_field.dart';
import '../widgets/custom_button.dart';
import '../screens/farmer_home_screen.dart' as farmer;

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _landCtrl = TextEditingController();
  final _cropCtrl = TextEditingController();
  bool _showPassword = false;

  String _selectedRole = 'farmer';

  final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  final RegExp passwordRegex = RegExp(r'^(?=.*[A-Z])(?=.*\d).{6,}$');

  @override
  Widget build(BuildContext context) {
    final fp = Provider.of<FarmerProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/registration_bg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Overlay
          Container(color: Colors.black.withOpacity(0.5)),

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
                      children: [
                        const Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 20),
                        CustomInputField(
                          controller: _nameCtrl,
                          label: 'Full Name',
                          icon: Icons.person,
                          validator: (value) =>
                              value!.isEmpty ? 'Required' : null,
                        ),
                        const SizedBox(height: 12),
                        CustomInputField(
                          controller: _phoneCtrl,
                          label: 'Phone',
                          icon: Icons.phone,
                          validator: (value) =>
                              value!.isEmpty ? 'Required' : null,
                        ),
                        const SizedBox(height: 12),
                        CustomInputField(
                          controller: _emailCtrl,
                          label: 'Email',
                          icon: Icons.email,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            if (!emailRegex.hasMatch(value)) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _passwordCtrl,
                          obscureText: !_showPassword,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock,
                                color: Colors.green),
                            border: const OutlineInputBorder(),
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
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            if (!passwordRegex.hasMatch(value)) {
                              return 'Min 6 characters, 1 uppercase & 1 number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
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
                          decoration:
                              const InputDecoration(labelText: 'Role'),
                        ),
                        const SizedBox(height: 12),
                        if (_selectedRole == 'farmer') ...[
                          CustomInputField(
                            controller: _landCtrl,
                            label: 'Land Size (ha)',
                            keyboardType: TextInputType.number,
                            icon: Icons.landscape,
                            validator: (value) =>
                                value!.isEmpty ? 'Required' : null,
                          ),
                          const SizedBox(height: 12),
                          CustomInputField(
                            controller: _cropCtrl,
                            label: 'Crop Type',
                            icon: Icons.grain,
                            validator: (value) =>
                                value!.isEmpty ? 'Required' : null,
                          ),
                        ],
                        const SizedBox(height: 20),
                        if (fp.error != null)
                          Text(fp.error!,
                              style: const TextStyle(color: Colors.red)),
                        const SizedBox(height: 12),
                        fp.isLoading
                            ? const CircularProgressIndicator()
                            : CustomButton(
                                text: 'Register',
                                onPressed: () async {
                                  if (!_formKey.currentState!.validate()) return;

                                  final generatedId = DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString();

                                  await fp.register(
                                    name: _nameCtrl.text,
                                    idNumber: generatedId,
                                    phone: _phoneCtrl.text,
                                    password: _passwordCtrl.text,
                                    role: _selectedRole,
                                    email: _emailCtrl.text,
                                    landSize: _selectedRole == 'farmer'
                                        ? double.tryParse(_landCtrl.text)
                                        : null,
                                    cropType: _selectedRole == 'farmer'
                                        ? _cropCtrl.text
                                        : null,
                                  );

                                  if (fp.error == null && context.mounted) {
                                    if (_selectedRole == 'farmer') {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const farmer.FarmerHomeScreen(),
                                        ),
                                      );
                                    } else if (_selectedRole == 'admin') {
                                      Navigator.pushReplacementNamed(
                                          context, '/admin-home');
                                    }
                                  }
                                },
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
}
