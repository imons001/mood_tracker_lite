import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

//--------Forgot password page----------

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/forest_begin.png',
            fit: BoxFit.cover,
          ), // end background image
          // translucent gradient overlay for readability
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.25), //lighter at top
                    Colors.black.withOpacity(0.25), //mid gradient
                    Colors.black.withOpacity(0.45), //darker at bottom
                  ],
                ),
              ),
            ),
          ), // end overlay Positioned.fill

          //Foreground container
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Enter your email to reset your password',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onSubmitted: (value) async {
                      try {
                        await FirebaseAuth.instance
                            .sendPasswordResetEmail(email: value);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Password reset email sent')),
                        );
                        Navigator.pop(context);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Error: ${e.toString()}'),
                          backgroundColor: Colors.red,
                        ) //snackbar
                            ); // Show error message
                      } // end try-catch
                    }, // end onSubmitted
                  ), // end TextField
                ], // closes children
              ), // closes Column
            ), // closes Padding
          ),
        ], // closes Stack children
      ), // closes Stack
    ); // closes Scaffold
  } // closes build()
} // closes class
