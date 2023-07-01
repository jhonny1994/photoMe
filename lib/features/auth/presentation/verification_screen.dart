import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photome/core/shared/utils.dart';
import 'package:photome/features/auth/providers.dart';
import 'package:photome/main.dart';

class VerificationScreen extends ConsumerStatefulWidget {
  const VerificationScreen(
    this.email,
    this.password, {
    super.key,
  });

  final String email;
  final String password;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<VerificationScreen> {
  bool canResendOtp = false;
  int counter = 60;
  final otp = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
              Text(
                'Welcome to PhotoMe!',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              smallGap(context),
              Text(
                'Enter the OTP sent to ${widget.email} to continue.',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              gap(context),
              TextFormField(
                controller: otp,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'OTP',
                  hintText: 'Enter your OTP',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
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
              smallGap(context),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (canResendOtp)
                    TextButton(
                      onPressed: () => ref
                          .read(authNotifierProvider.notifier)
                          .signUp(widget.email, widget.password),
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
