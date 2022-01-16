import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:group_chat_flutter/screens/welcome_screen.dart';
import 'package:group_chat_flutter/screens/login_screen.dart';
import 'package:group_chat_flutter/screens/registration_screen.dart';
import 'package:group_chat_flutter/screens/chat_screen.dart';

void main() {WidgetsFlutterBinding.ensureInitialized();
 Firebase.initializeApp();
 runApp(GroupChat());}

class GroupChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFF363636),
        scaffoldBackgroundColor: Colors.white12,
        // ignore: prefer_const_constructors
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.black54),
        ),
      ),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        ChatScreen.id: (context) => ChatScreen(),
      },
    );
  }
}
