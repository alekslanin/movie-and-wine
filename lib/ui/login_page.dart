import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wineandmovie/auth_service.dart';
import 'package:wineandmovie/routing/names.dart';
import 'package:wineandmovie/routing/router.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_updateValidity);
    _passwordController.addListener(_updateValidity);
    _updateValidity();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

String message = 'N/A';

    try {
      await authService.value.signIn
      (
        _emailController.text.trim(), 
        _passwordController.text
      );
      message = 'Login successful.';
    } on FirebaseAuthException catch (e) {
        print(e.code);
        print(e.message);
      message = e.message ?? 'Login failed.';
    } catch (_) {
      if(mounted) {
        message = 'Login failed';
      }
    } finally {
        if(mounted) {
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
           setState(() => _loading = false);
        }
    }
  }

  void _updateValidity() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final emailValid = RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+$").hasMatch(email);
    final valid = email.isNotEmpty && emailValid && password.length >= 6;
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

  void _goToRegister() {
    AppRouter.pushReplacement(context, RoutingNames.register);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign in')),
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
                      if (!RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+$").hasMatch(v)) return 'Enter a valid email';
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
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (_loading || !_isValid) ? null : _signIn,
                      child: _loading
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Text('Sign in'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      TextButton(onPressed: _loading ? null : _goToRegister, child: const Text('Register')),
                    ],
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