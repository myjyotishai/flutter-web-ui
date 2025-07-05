import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../app_state.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoginMode = true;
  bool loading = false;
  String error = '';

  Future<void> authenticate() async {
    final email = emailController.text;
    final password = passwordController.text;

    setState(() {
      loading = true;
      error = '';
    });

    try {
      final endpoint = isLoginMode ? 'login' : 'register';
      final uri = Uri.parse('https://fastapi-cayc.onrender.com/$endpoint');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: '{"email": "$email", "password": "$password"}',
      );

      if (response.statusCode == 200) {
        final token = 'dummy-token'; // In real use, parse from response
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('email', email);

        Provider.of<AppState>(context, listen: false).login(token, email);
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        setState(() => error = 'Failed: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => error = 'Error: $e');
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _checkLoggedIn();
  }

  void _checkLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final email = prefs.getString('email');
    if (token != null && email != null) {
      Provider.of<AppState>(context, listen: false).login(token, email);
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isLoginMode ? 'Login' : 'Register')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            if (error.isNotEmpty) ...[
              SizedBox(height: 8),
              Text(error, style: TextStyle(color: Colors.red)),
            ],
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: loading ? null : authenticate,
              child: loading
                  ? CircularProgressIndicator()
                  : Text(isLoginMode ? 'Login' : 'Register'),
            ),
            TextButton(
              onPressed: () {
                setState(() => isLoginMode = !isLoginMode);
              },
              child: Text(isLoginMode
                  ? "Don't have an account? Register"
                  : "Already registered? Login"),
            )
          ],
        ),
      ),
    );
  }
}
