import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../app_state.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String error = '';
  bool loading = false;

  Future<void> loginUser() async {
    setState(() {
      loading = true;
      error = '';
    });

    final uri = Uri.parse('https://fastapi-cayc.onrender.com/login');
    final res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': _emailController.text,
        'password': _passwordController.text,
      }),
    );

    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      final token = data['access_token'];
      final email = _emailController.text;

      Provider.of<AppState>(context, listen: false).login(token, email);

      Navigator.pushReplacementNamed(context, '/');
    } else {
      setState(() {
        error = 'Login failed';
      });
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            if (error.isNotEmpty)
              Text(error, style: TextStyle(color: Colors.red)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: loading ? null : loginUser,
              child: loading ? CircularProgressIndicator() : Text('Login'),
            ),
            TextButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/'),
              child: Text('Continue as Guest'),
            )
          ],
        ),
      ),
    );
  }
}
