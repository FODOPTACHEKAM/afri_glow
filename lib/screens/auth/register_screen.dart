import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {

  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Account"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: ListView(
          children: [

            TextField(
              decoration: InputDecoration(
                labelText: "Full Name",
              ),
            ),

            TextField(
              decoration: InputDecoration(
                labelText: "Email",
              ),
            ),

            TextField(
              decoration: InputDecoration(
                labelText: "Phone Number",
              ),
            ),

            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
              ),
            ),

            SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {},
              child: Text("Register"),
            )
          ],
        ),
      ),
    );
  }
}