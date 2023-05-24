import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:quickalert/quickalert.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'paramedis/paramedis_screen.dart';
import 'dokter/dokter_screen.dart';
import 'mahasiswa/aaa_mahasiswa_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    isObscured = false;
  }

  late bool isObscured;

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> loginAction(String username, String password, BuildContext context) async {
    final response = await http.post(
      Uri.parse('http://192.168.1.3:8000/api/login'),
      // Uri.parse('http://yntkts.ddns.net:8000/api/login'),
      body: {
        'username': username,
        'password': password,
      },
    );

    String role;
    if (response.statusCode == 200) {
      role = jsonDecode(response.body)['role'];
      final token = jsonDecode(response.body)['token'];
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token.toString());
    } else {
      throw Exception();
    }

    if (context.mounted) {
      if (role == 'Mahasiswa') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MahasiswaScreen()),
        );
      } else if (role == 'Dokter') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DokterScreen()),
        );
      } else if (role == 'Paramedis') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ParamedisScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const HSLColor.fromAHSL(1, 201, 0.89, 0.96).toColor(),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 25,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/TelkomSehat.png',
                    width: 50,
                    height: 50,
                  ),
                  const SizedBox(width: 10.0),
                  const Text(
                    'TelkomSehat',
                    style: TextStyle(
                      color: Color(0xff012970),
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: const Color(0xffffffff),
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 5,
                    offset: const Offset(0, 0), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      "Masuk ke Akun Anda",
                      style: GoogleFonts.montserrat(
                        color: const Color(0xff012970),
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 13),
                    child: Text(
                      "Masukkan Username & Password untuk masuk",
                      style: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      prefixIcon: Icon(LineIcons.at),
                    ),
                  ),
                  const SizedBox(height: 12.5),
                  TextField(
                    controller: passwordController,
                    keyboardType: TextInputType.text,
                    obscureText: !isObscured,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(!isObscured
                            ? LineIcons.eyeSlashAlt
                            : LineIcons.eye),
                        onPressed: () {
                          setState(() {
                            isObscured = !isObscured;
                          });
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          await loginAction(
                              usernameController.text, passwordController.text, context);
                        } catch (e) {
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.error,
                            text: 'Username and/or Password Incorrect!',
                            backgroundColor: Colors.white60,
                            barrierColor: Colors.black.withOpacity(0.85),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // warna background
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
