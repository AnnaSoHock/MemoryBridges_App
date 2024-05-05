import 'package:flutter/material.dart';
import 'mainHomeScreen.dart';
import 'dart:developer';
import 'package:app_memory_bridge/auth_service.dart';
import 'package:app_memory_bridge/signUpScreen.dart';
import 'package:app_memory_bridge/widgets/button.dart';
import 'package:app_memory_bridge/widgets/textfield.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = AuthService();

  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            const Spacer(),
            const Text("Login",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500, fontFamily: 'LibreBaskerville',)),
            const SizedBox(height: 50),
            CustomTextField(
              hint: "Enter Email",
              label: "Email",
              controller: _email,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              hint: "Enter Password",
              label: "Password",
              isPassword: true, // Set this to true to hide the password input with dots
              controller: _password,
            ),
            const SizedBox(height: 30),
            CustomButton(
              label: "Login",
              onPressed: _login,
            ),
            const SizedBox(height: 5),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text("Don't have an account yet? "),
              InkWell(
                onTap: () => goToSignup(context),
                child:
                const Text("Signup", style: TextStyle(color: Colors.red)),
              )
            ]),
            const Spacer()
          ],
        ),
      ),
    );
  }

  goToSignup(BuildContext context) => Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const SignUpScreen()),
  );

  goToHome(BuildContext context) => Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const MainHomeScreen()),
  );

  _login() async {
    final user =
    await _auth.loginUserWithEmailAndPassword(_email.text, _password.text);

    if (user != null) {
      log("User Logged In");
      goToHome(context);
    }
  }
}
