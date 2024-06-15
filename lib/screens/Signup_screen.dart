import 'dart:convert';
import 'package:assignment1/screens/nav.dart';
import 'package:assignment1/theme/theme.dart';
import 'package:assignment1/widgets/custom_scaff.dart';
import 'package:assignment1/widgets/input.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'config.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();

  bool isNotValidate = false;

  final _formKey = GlobalKey<FormState>();

  void registerUser() async {
    try {
      var reqBody = {"email": email.text, "password": pass.text};

      var resp = await http.post(Uri.parse(registration),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(reqBody));

      var jsonResp = jsonDecode(resp.body);

      if (jsonResp['status'] == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => navBar(),
          ),
        );
      } else {
        print("something went wronmg");
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Email already taken")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold2(
        child: Form(
      key: _formKey,
      child: Column(children: [
        Expanded(
            flex: 1,
            child: SizedBox(
              height: 10,
            )),
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
                    Text(
                      "Register Here !",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: lightColorScheme.primary),
                    ),
                    const SizedBox(height: 15),
                    CustomizedInput(
                      controller: email,
                      obscureText: false,
                      hint: 'email',
                      type: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 15),
                    CustomizedInput(
                      controller: pass,
                      obscureText: true,
                      hint: 'password',
                      type: TextInputType.text,
                    ),
                    SizedBox(height: 15),
                    Container(
                      height: MediaQuery.of(context).size.height / 15,
                      width: MediaQuery.of(context).size.width / 3,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Processing data")));
                            registerUser();
                          }
                        },
                        child: const Text("Register"),
                      ),
                    )
                  ],
                )),
              ),
            )),
      ]),
    ));
  }
}
