//dependency imports
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//footer
import '../widgets/bottom.dart';

//routes
import '../routes/routes.dart';

//main widget for profile page

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

//state class for profile page
class _ProfilePageState extends State<ProfilePage> {
  final User? user = FirebaseAuth.instance.currentUser;
//background image
  final String _forestBackground = 'assets/images/background.jpg';
  //contorller for handling user data
  //final UserController _userController = UserController();
  //idk shit some history maybe

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar:
          true, // allows background image to go under app bar

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ), // end of app bar

      //main body layout

      body: Stack(
        children: [
          //background image
          Positioned.fill(
            child: Image.asset(
              _forestBackground,
              fit: BoxFit.cover,
            ),
          ), //pos fill

          //translucent gradient overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.25),
                    Colors.black.withOpacity(0.45),
                    Colors.black.withOpacity(0.65),
                  ],
                ),
              ),
            ),
          ), // end overlay Positioned.fill

          //centered

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Logged in as: ${user?.email ?? 'Guest'}',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white, // ✅ so you can actually see it
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushNamedAndRemoveUntil(
                        context, Routes.moodPage, (route) => false);
                  },
                  child: const Text('Logout'),
                ),
              ],
            ),
          ),
        ],
      ), // end of stack
      bottomNavigationBar: BottomMenu(
        currentIndex: 3,
        onItemTapped: (index) {
          // Handle item tap
          switch (index) {
            case 0:
              Navigator.pushNamed(context, Routes.insights);
              break;
            case 1:
              Navigator.pushNamed(context, Routes.moodPage);
              break;
            case 2: //not made yet
              // Navigator.pushNamed(context, Routes.notifications);
              break;
            case 3: //current
              Navigator.pushNamed(context, Routes.profilePage);
              break;
          }
        },
      ),
    );
  }
}
