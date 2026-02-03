import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Stack(
          children: [
            // Background image/color
            Positioned.fill(
              child: Image.network(
                'https://picsum.photos/500/500',
                fit: BoxFit.cover,
                color: Colors.black.withOpacity(0.3),
              ),
            ),

            // Login form centered
            Center(
              child: Container(
                padding: EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // App logo or title
                      Center(child: Image.asset("assets/icon/app_logo.png", height: 85)),
                      Text(
                        'Capital Signals',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),

                      SizedBox(height: 20),

                      // Email field
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Email'),
                        onChanged: (value) => _email = value,
                        validator: (value) => value!.isEmpty ? 'Please enter email' : null,
                      ),
                      SizedBox(height: 20),
                      // Password field
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Password'),
                        obscureText: true,
                        onChanged: (value) => _password = value,
                        validator: (value) => value!.isEmpty ? 'Please enter password' : null,
                      ),

                      SizedBox(height: 40),

                      // Login button
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              await _auth.signInWithEmailAndPassword(email: _email, password: _password);
                              // Navigate to home screen or other relevant screen
                            } on FirebaseAuthException catch (e) {
                              // Handle authentication errors
                              print(e);
                            }
                          }
                        },
                        child: Text('Login'),
                      ),

                      SizedBox(height: 10),

                      // Create account link
                      TextButton(
                        onPressed: () {
                          //Navigator.pushNamed('/register');
                        },
                        child: Text('Don\'t have an account? Create one'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
