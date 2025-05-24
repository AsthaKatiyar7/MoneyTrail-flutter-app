import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/utils/logger.dart';
import '../../providers/auth_provider.dart';
import '../common/custom_button.dart';
import '../common/input_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    print('SignupScreen: _signUp method called');  // Basic debug print
    Logger.info('Starting signup process...');
    
    if (!(_formKey.currentState?.validate() ?? false)) {
      Logger.warn('Form validation failed');
      return;
    }

    final username = _usernameController.text.trim();
    final password = _passwordController.text;
    
    Logger.info('Attempting to sign up user: $username');
    Logger.info('Password length: ${password.length}');

    try {
      final success = await context.read<AuthProvider>().signUp(
            username: username,
            password: password,
          );

      if (success) {
        Logger.info('Signup successful, navigating to dashboard');
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/dashboard');
        }
      } else {
        Logger.warn('Signup failed but no exception was thrown');
      }
    } catch (e, stackTrace) {
      Logger.error(
        'Unexpected error during signup',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Join Money Trail',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              InputField(
                label: 'Username',
                controller: _usernameController,
                textInputAction: TextInputAction.next,
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
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter a password';
                  }
                  if (value!.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              InputField(
                label: 'Confirm Password',
                controller: _confirmPasswordController,
                isPassword: true,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _signUp(),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please confirm your password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
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
                text: 'Create Account',
                onPressed: _signUp,
                isLoading: authProvider.isLoading,
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: 'Already have an account? Login',
                onPressed: () {
                  Navigator.pop(context);
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
