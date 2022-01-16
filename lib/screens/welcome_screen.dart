import 'package:flutter/material.dart';
import 'package:group_chat_flutter/screens/registration_screen.dart';
import 'login_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'BlueRoundButton.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );

    animation = CurvedAnimation(parent: _controller, curve: Curves.decelerate);
    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white12)
        .animate(_controller);

    _controller.forward();
    animation.addStatusListener((status) {
      if (status == animation.isCompleted) {
        _controller.reverse(from: 1);
      } else if (status == animation.isDismissed) {
        _controller.forward();
      }
    });
    _controller.addListener(() {
      setState(() {
        //print(animation.value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  //${_controller.value.toInt()}%
                  text: ['Flash Chat'],
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 35.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(Colors.blue, 'Login', () {
              Navigator.pushNamed(context, LoginScreen.id);
            }),
            RoundedButton(Colors.blue, 'Register', () {
              Navigator.pushNamed(context, RegistrationScreen.id);
            }),
          ],
        ),
      ),
    );
  }
}
