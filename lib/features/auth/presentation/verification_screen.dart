import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photome/core/providers.dart';
import 'package:photome/main.dart';

class VerificationScreen extends ConsumerStatefulWidget {
  const VerificationScreen(
    this.email,
    this.password,
    this.username, {
    super.key,
  });

  final String email;
  final String password;
  final String username;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<VerificationScreen> {
  final otp = TextEditingController();
  bool canResendOtp = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _gap() =>
      SizedBox(height: MediaQuery.of(context).viewInsets.bottom == 0 ? 16 : 8);

  int counter = 60;

  @override
  void initState() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        counter--;
      });
      if (counter == 0) {
        setState(() {
          canResendOtp = true;
        });
        timer.cancel();
      }
    });
    super.initState();
  }

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
              CircleAvatar(
                radius:
                    MediaQuery.of(context).viewInsets.bottom == 0 ? 100 : 50,
                backgroundImage: const AssetImage('assets/images/logo.png'),
              ),
              _gap(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Welcome to PhotoMe!',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Enter the OTP sent to ${widget.email} to continue.',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ),
              _gap(),
              TextFormField(
                controller: otp,
                decoration: const InputDecoration(
                  labelText: 'OTP',
                  hintText: 'Enter your OTP',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              _gap(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Verify OTP',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      await ref.read(authNotifierProvider.notifier).verifyOtp(
                            widget.email,
                            otp.text,
                          );
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
              _gap(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (canResendOtp)
                    TextButton(
                      onPressed: () =>
                          ref.read(authNotifierProvider.notifier).signUp(
                                widget.email,
                                widget.password,
                                widget.username,
                              ),
                      child: const Text('Resend OTP'),
                    )
                  else
                    Text('You can request a new OTP in: ${counter}s'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
