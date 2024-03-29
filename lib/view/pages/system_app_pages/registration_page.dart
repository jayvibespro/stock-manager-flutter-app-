import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stocksmanager/services/auth_services.dart';
import 'package:stocksmanager/services/wallet_service.dart';

import '../drawer_pages/home_page.dart';
import 'login_page.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  bool isLoading = false;

  TextEditingController userNameController = TextEditingController();
  TextEditingController? emailController = TextEditingController();
  TextEditingController? passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.amberAccent,
                borderRadius:
                    BorderRadius.only(bottomLeft: Radius.circular(120)),
              ),
              child: Stack(
                children: [
                  Positioned(
                    child: Container(
                      margin: const EdgeInsets.only(top: 100),
                      decoration: const BoxDecoration(),
                      child: const Center(
                        child: Text(
                          'Join Us',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(143, 148, 251, 1),
                            blurRadius: 20.0,
                            offset: Offset(2, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // ignore: avoid_unnecessary_containers
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(),
                            child: TextField(
                              controller: userNameController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'User name',
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(),
                            child: TextField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Email',
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(),
                            child: TextField(
                              obscureText: true,
                              controller: passwordController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Password',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    GestureDetector(
                      child: Container(
                        width: double.infinity,
                        height: 60,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.amberAccent,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(143, 148, 251, 1),
                              blurRadius: 20.0,
                              offset: Offset(2, 6),
                            ),
                          ],
                        ),
                        child: Center(
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  'Register',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                        ),
                      ),
                      onTap: () async {
                        setState(() {
                          isLoading = true;
                        });

                        AuthServices(
                                email: emailController!.text,
                                password: passwordController!.text)
                            .createUser(userNameController.text);
                        await Future.delayed(const Duration(seconds: 3));

                        if (auth.currentUser != null) {
                          setState(() {
                            isLoading = false;
                          });

                          WalletService(
                            userId: auth.currentUser?.uid,
                            income: 0,
                            expense: 0,
                          ).createWallet();

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()));
                        } else {
                          setState(() {
                            isLoading = false;
                          });
                          Get.snackbar("Error",
                              "Failed to create user. Please try again.",
                              snackPosition: SnackPosition.BOTTOM,
                              borderRadius: 20,
                              duration: const Duration(seconds: 4),
                              margin: const EdgeInsets.all(15),
                              isDismissible: true,
                              dismissDirection: DismissDirection.horizontal,
                              forwardAnimationCurve: Curves.easeInOutBack);
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Text('Already have an account?'),
                          TextButton(
                            onPressed: () async {
                              print(isLoading);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()));
                            },
                            child: const Text('Login here'),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
