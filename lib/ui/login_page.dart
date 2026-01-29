import 'package:country_flags/country_flags.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:wineandmovie/auth_service.dart';
import 'package:wineandmovie/notification_service.dart';
import 'package:wineandmovie/ui/email_pass_validators.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> with EmailPassValidators {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;
  //bool _isValid = false;

  @override
  void initState() {
    super.initState();
    // _emailController.addListener(_updateValidity);
    // _passwordController.addListener(_updateValidity);
    // _updateValidity();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn(String emaail, String pwd) async {
    //if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    String message = 'N/A';

    try {
      await AuthService().signIn
      (
        emaail, 
        pwd
      );
      message = 'Login successful for ${_emailController.text.trim()}';
      Logger().i(message);
      if (mounted) {
        context.goNamed('wine');
        //AppRouter.pushReplacement(context, RoutingNames.wine);  // TODO: fix me
      }
    } on FirebaseAuthException catch (e) {
        Logger().e(e.code);
        Logger().e(e.message);
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

  void _goToRegister() {
    context.goNamed('register');
     //AppRouter.pushReplacement(context, RoutingNames.register);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign in')),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 70, top: 12),
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () => {Logger().i('japan pressed')},
                isSelected: false,
                icon:  CountryFlag.fromCountryCode(
                            'JP',
                            theme: const ImageTheme(width: 24, height: 16, shape: RoundedRectangle(3),),
                          )
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 30, top: 12),
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () => {Logger().i('usa pressed')},
                isSelected: true,
                icon:  CountryFlag.fromCountryCode(
                            'US',
                            theme: const ImageTheme(width: 24, height: 16, shape: RoundedRectangle(3),),
                          )
                  ),
            ),
          ),
         
          Center(
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
                          //helperText: _isEmailValid() ? null : 'Enter a valid email address',
                        ),
                        validator: validateEmail,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          //helperText: _isPasswordValid() ? '' : 'Minimum 6 characters',
                        ),
                        obscureText: true,
                        validator: validatePassword,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // make sure the form is valid
                            // before submitting
                            if (_formKey.currentState!.validate()) {
                              _signIn(_emailController.text.trim(), _passwordController.text.trim());
                            }
                          },
                          //onPressed: (_loading || !_isValid) ? null : _signIn,
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
        ],
      ),
    );
  }
}