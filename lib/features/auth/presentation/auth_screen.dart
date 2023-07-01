import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photome/core/shared/utils.dart';
import 'package:photome/features/auth/providers.dart';
import 'package:photome/main.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<AuthScreen> {
  final email = TextEditingController();
  bool isSignUp = true;
  final password = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${isSignUp ? 'Sign up' : 'Sign in'} to PhotoMe!',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              smallGap(context),
              Text(
                'Enter your email and password to ${isSignUp ? 'create a new account' : 'log to your account'}.',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              gap(context),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  final emailValid = RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                  ).hasMatch(value);
                  if (!emailValid) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
                controller: email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              gap(context),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
                textInputAction: TextInputAction.done,
                controller: password,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              gap(context),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      isSignUp ? 'Sign up' : 'Sign in',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      isSignUp
                          ? await ref
                              .read(authNotifierProvider.notifier)
                              .signUp(email.text.trim(), password.text)
                          : await ref
                              .read(authNotifierProvider.notifier)
                              .signIn(email.text.trim(), password.text);
                      if (mounted) {
                        await Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute<Widget>(
                            builder: (context) => const MainApp(),
                          ),
                          (route) => false,
                        );
                      }
                    }
                  },
                ),
              ),
              smallGap(context),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("don't have an account?"),
                  TextButton(
                    onPressed: () => setState(() {
                      isSignUp = !isSignUp;
                    }),
                    child: Text(
                      !isSignUp ? 'Sign up' : 'Sign in',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
