import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

//--------Forgot password page----------

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/forest_begin.png',
            fit: BoxFit.cover,
          ), // end background image

          //Foreground container
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Enter your email to reset your password',
                  style: TextStyle(fontSize: 18),
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
        ], // closes children
      ), // closes Stack
    ); // closes Scaffold
  } // closes build()
} // closes class
