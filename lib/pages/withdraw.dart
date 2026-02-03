import 'package:flutter/material.dart';

class WithdrawPage extends StatefulWidget {
  const WithdrawPage({super.key});

  @override
  State<WithdrawPage> createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> {


  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Withdraw'),),
      body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Center(child: Image.asset("assets/icon/app_logo.png", height: 85)),
                    SizedBox(height: 80),
                    // Email field
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Account Name'),
                      onChanged: (value) => _email = value,
                      validator: (value) => value!.isEmpty ? 'Please enter your account name' : null,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Account Number'),
                      onChanged: (value) => _email = value,
                      validator: (value) => value!.isEmpty ? 'Please enter your account number' : null,
                    ),
                    SizedBox(height: 20),
                    SizedBox(height: 40),

                    // Login or signup button, depending on _isLogin flag
                    ElevatedButton(
                      onPressed: () async {

                      },
                      child: Text('          Confirm Withdraw          '),
                    ),
                  ]))),
    );
  }
}
