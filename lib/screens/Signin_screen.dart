import 'dart:convert';

import 'package:assignment1/screens/config.dart';
import 'package:assignment1/screens/home.dart';
import 'package:assignment1/screens/nav.dart';
import 'package:assignment1/theme/theme.dart';
import 'package:assignment1/widgets/custom_scaff.dart';
import 'package:assignment1/widgets/input.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late SharedPreferences prefs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  void loginUser() async {
    var reqBody = {"email": email.text, "password": password.text};

    var resp = await http.post(Uri.parse(login),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody));

    var jsonResp = jsonDecode(resp.body);

    if (jsonResp['status'] == 200) {
      print('login successfully');
      var myToken = jsonResp['token'];
      prefs.setString("token", myToken);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Processing data"),
        duration: Duration(seconds: 2),
      ));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            token: myToken,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Wrong username or password"),
        duration: Duration(seconds: 2),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold2(
      child: Form(
        key: _formKey,
        child: Column(children: [
          const Expanded(
            flex: 1,
            child: SizedBox(
              height: 10,
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Text(
                            "Welcome Back!",
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                                color: lightColorScheme.primary),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        CustomizedInput(
                          controller: email,
                          obscureText: false,
                          hint: "Email",
                          type: TextInputType.emailAddress,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        CustomizedInput(
                          controller: password,
                          obscureText: true,
                          hint: "Password",
                          type: TextInputType.text,
                        ),
                        SizedBox(height: 30),
                        Text(
                          "Forget Password ?",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              decorationColor: lightColorScheme.primary,
                              color: lightColorScheme.primary),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height / 15,
                          width: MediaQuery.of(context).size.width / 3,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                loginUser();
                              }
                            },
                            child: Text("Login"),
                          ),
                        )
                      ],
                    ),
                  ),
                )),
          )
        ]),
      ),
    );
  }
}
