import 'package:flutter/material.dart';
import 'package:task_manager/screens/home/home-screen/home_screen.dart';
import 'package:task_manager/services/firebase/auth/firebase_auth.dart';
import 'package:task_manager/widgets/button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  FocusNode emailFocus = FocusNode();
  TextEditingController passwordController = TextEditingController();
  FocusNode passwordFocus = FocusNode();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color(0xFFB8E1DD),
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: emailController,
                  focusNode: emailFocus,
                  decoration: const InputDecoration(labelText: 'E-mail'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'E-mail cant be empty';
                    } else if (!value.contains('@')) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                  onEditingComplete: () {
                    _fieldFocusChange(context, emailFocus, passwordFocus);
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: passwordController,
                  focusNode: passwordFocus,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Password cant be empty';
                    }
                    return null;
                  },
                  //onEditingComplete: register,
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      var navigator = Navigator.of(context);
                      await AuthenticationServices()
                          .login(emailController.text, passwordController.text);
                      navigator.pushReplacement(
                        MaterialPageRoute(
                          builder: (navigateTo) => const HomeScreen(),
                        ),
                      );
                    }
                  },
                  child: const Text('Login'),
                ),
                Button(title: "Login"),
                Button(title: "Do it to me please")
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void _fieldFocusChange(
  BuildContext context,
  FocusNode currentFocus,
  FocusNode nextFocus,
) {
  currentFocus.unfocus();
  FocusScope.of(context).requestFocus(nextFocus);
}
