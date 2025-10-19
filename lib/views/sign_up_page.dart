// Sign Up Page
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mood_tracker_lite/views/mood_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Sign-up logic
  Future<void> _signUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MoodPage()),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Firebase error: ${e.code} — ${e.message}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unexpected error: $e')),
      );
    }
  } //closes try

  /*
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Go to MoodPage after successful signup
      if (!mounted) return; //idk why this is needed here but ok
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MoodPage()),
      );
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'weak-password') {
        message = 'The password is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'This email is already in use.';
      } else if (e.code == 'invalid-email') {
        message = 'The email address is not valid.';
      } else {
        message = 'Sign-up failed: ${e.message}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // opens Scaffold
      appBar: AppBar(
        title: const Text('Sign Up'),
      ), // closes AppBar

      body: Stack(
        // opens Stack
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/forest_begin.png',
            fit: BoxFit.cover,
          ), // closes background image

          // Foreground container
          Padding(
            // opens Padding
            padding: const EdgeInsets.all(16.0),
            child: Column(
              // opens Column
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Create a new account',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ), // closes Text

                const SizedBox(height: 20), // closes SizedBox

                SizedBox(
                  width: 300,
                  height: 60,
                  child: TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      filled: true, //closes filled
                      fillColor: Colors.white70, //transparent
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ), // closes Email TextField
                ), // closes SizedBox

                const SizedBox(height: 10), // closes SizedBox

                SizedBox(
                  width: 300,
                  height: 60,
                  child: TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      filled: true,
                      fillColor: Colors.white70,
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ), // closes Password TextField
                ), // closes SizedBox

                const SizedBox(height: 20), // closes SizedBox

                ElevatedButton(
                  onPressed: _signUp, // ✅ direct call
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 15,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text('Sign Up'),
                ), // ✅ closes ElevatedButton

                const SizedBox(height: 15),

                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Back to Login',
                    style: TextStyle(color: Colors.white),
                  ),
                ), // ✅ closes TextButton
              ], // closes children
            ), // closes Column
          ), // closes Padding
        ], // closes children
      ), // closes Stack
    ); // closes Scaffold
  } // closes build
} // closes class
