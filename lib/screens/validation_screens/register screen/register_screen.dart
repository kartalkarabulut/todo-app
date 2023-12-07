import 'package:flutter/material.dart';
import 'package:task_manager/models/user_model.dart';
import 'package:task_manager/screens/home/home-screen/home_screen.dart';
import 'package:task_manager/screens/validation_screens/login%20screen/login_screen.dart';
import 'package:task_manager/services/firebase/auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  FocusNode emailFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  FocusNode nameFocus = FocusNode();
  TextEditingController passwordController = TextEditingController();
  FocusNode passwordFocus = FocusNode();
  TextEditingController surnameController = TextEditingController();
  FocusNode surnameFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color(0xFFB8E1DD),
      appBar: AppBar(
        title: const Text("Register Page"),
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
                  controller: nameController,
                  focusNode: nameFocus,
                  decoration: const InputDecoration(labelText: 'Ad'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Name cant be empty";
                    }
                    return null;
                  },
                  onEditingComplete: () {
                    _fieldFocusChange(context, nameFocus, surnameFocus);
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: surnameController,
                  focusNode: surnameFocus,
                  decoration: const InputDecoration(labelText: 'Surname'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Surname cant be empty';
                    }
                    return null;
                  },
                  onEditingComplete: () {
                    _fieldFocusChange(context, surnameFocus, emailFocus);
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
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
                      await AuthenticationServices().register(Kullanici(
                          name: nameController.text,
                          surname: surnameController.text,
                          email: emailController.text,
                          password: passwordController.text));
                      navigator.push(
                        MaterialPageRoute(
                          builder: (navigateTo) => const HomeScreen(),
                        ),
                      );
                    }
                  },
                  child: const Text('Register'),
                ),
              ],
            ),
          ),
          TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              },
              child: const Text("Login"))
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
