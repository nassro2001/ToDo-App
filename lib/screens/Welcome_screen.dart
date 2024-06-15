import 'package:assignment1/screens/Signin_screen.dart';
import 'package:assignment1/screens/Signup_screen.dart';
import 'package:assignment1/theme/theme.dart';
import 'package:assignment1/widgets/custom_btn.dart';
import 'package:assignment1/widgets/custom_scaff.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold2(
      child: Column(children: [
        Flexible(
            flex: 8,
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 40.0,
              ),
              child: Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children: [
                    TextSpan(
                        text: "TODO App !\n",
                        style: TextStyle(
                          fontSize: 45.0,
                          fontWeight: FontWeight.w600,
                        )),
                    TextSpan(
                        text:
                            "\nEnter personal details to start your training journey",
                        style: TextStyle(
                          fontSize: 20,
                        ))
                  ]),
                ),
              ),
            )),
        Flexible(
          flex: 1,
          child: Align(
            alignment: Alignment.bottomRight,
            child: Row(
              children: [
                Expanded(
                    child: CustomBtn(
                  btnText: 'SignIn',
                  onTap: SigninScreen(),
                  color: Colors.transparent,
                  textColor: Colors.white,
                )),
                Expanded(
                    child: CustomBtn(
                  btnText: 'SignUp',
                  onTap: SignupScreen(),
                  color: Colors.white,
                  textColor: lightColorScheme.primary,
                )),
              ],
            ),
          ),
        )
      ]),
    );
  }
}
