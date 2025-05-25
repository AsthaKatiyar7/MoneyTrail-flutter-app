import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../common/custom_button.dart';
import '../common/input_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      final success = await context.read<AuthProvider>().login(
        username: _usernameController.text.trim(),
        password: _passwordController.text,
      );

      if (success && mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/dashboard',
          (route) => false, // Remove all previous routes
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Welcome Back!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              InputField(
                label: 'Username',
                controller: _usernameController,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              InputField(
                label: 'Password',
                controller: _passwordController,
                isPassword: true,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _login(),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your password';
                  }
                  if (value!.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              if (authProvider.error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    authProvider.error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              CustomButton(
                text: 'Login',
                onPressed: _login,
                isLoading: authProvider.isLoading,
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: 'Create Account',
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
                isOutlined: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
