import 'package:flutter/material.dart';

// all pages
import '../views/insights.dart';
import '../views/mood_page.dart';
// import '../views/blank_pages.dart';
import '../views/profile.dart';
import '../views/login_page.dart';
import '../views/sign_up_page.dart';
import '../views/forgot_password.dart';

class Routes {
  static const String login = '/login';
  static const String signUp = '/signUp';
  static const String forgotPassword = '/forgotPassword';
  static const String insights = '/insights';
  static const String moodPage = '/moodPage';
  // static const String blankPages = '/blankPages';
  static const String profilePage = '/profilePage';

//single map
  static Map<String, WidgetBuilder> routes = {
    login: (context) => LoginPage(),
    signUp: (context) => SignUpPage(),
    forgotPassword: (context) => ForgotPasswordPage(),
    insights: (context) => Insights(),
    moodPage: (context) => MoodPage(),
    // blankPages: (context) => BlankPages(),
    profilePage: (context) => ProfilePage(),
  };
}
