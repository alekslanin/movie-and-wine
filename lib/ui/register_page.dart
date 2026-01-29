import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:wineandmovie/auth_service.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _loading = false;
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_updateValidity);
    _passwordController.addListener(_updateValidity);
    _confirmPasswordController.addListener(_updateValidity);
    _updateValidity();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _updateValidity() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    final emailValid = RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+$").hasMatch(email);
    final passwordValid = password.length >= 6;
    final passwordsMatch = password == confirmPassword && password.isNotEmpty;
    final valid = email.isNotEmpty && emailValid && passwordValid && passwordsMatch;
    if (mounted && valid != _isValid) setState(() => _isValid = valid);
  }

  bool _isEmailValid() {
    final email = _emailController.text.trim();
    return email.isNotEmpty && RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+$").hasMatch(email);
  }

  bool _isPasswordValid() {
    final password = _passwordController.text;
    return password.length >= 6;
  }

  bool _isConfirmPasswordValid() {
    final password = _passwordController.text;
    final confirm = _confirmPasswordController.text;
    return confirm.isNotEmpty && confirm == password;
  }

  Future<void> _register() async {
    
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    
    String message = 'N/A';

    try {
      await AuthService().register
      (
        _emailController.text.trim(), 
        _passwordController.text
      );
      message = 'Registration successful. You can now log in.';
      Logger().i(message);

    } on FirebaseAuthException catch (e) {
        Logger().e(e.code);
        Logger().e(e.message);
      message = e.message ?? 'Registration failed.';
    } catch (_) {
      if(mounted) {
        message = 'Registration failed';
      }
    } finally {
        if(mounted) {
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
           setState(() => _loading = false);
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      helperText: _isEmailValid() ? null : 'Enter a valid email address',
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Enter your email';
                      if (!RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+$").hasMatch(v)) return 'Email is invalid (e.g., user@example.com)';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      helperText: _isPasswordValid() ? '' : 'Minimum 6 characters',
                    ),
                    obscureText: true,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Enter your password';
                      if (v.length < 6) return 'Password must be at least 6 characters';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      helperText: _isConfirmPasswordValid() ? '' : 'Must match your password',
                    ),
                    obscureText: true,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Confirm your password';
                      if (v != _passwordController.text) return 'Passwords do not match';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (_loading || !_isValid) ? null : _register,
                      child: _loading
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Text('Submit'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}