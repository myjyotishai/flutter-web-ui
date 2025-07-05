# This is Dart/Flutter code and should be run inside a Flutter environment like Android Studio or VS Code, not in a Python interpreter.

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(JyotishAIApp());
}

class JyotishAIApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JyotishAI',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: LanguageSelectionScreen(),
    );
  }
}

class LanguageSelectionScreen extends StatelessWidget {
  final List<String> languages = ['English', 'Hindi', 'Bhojpuri', 'Telugu'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Language')),
      body: ListView.builder(
        itemCount: languages.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(languages[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RashifalForm(language: languages[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class RashifalForm extends StatefulWidget {
  final String language;
  RashifalForm({required this.language});

  @override
  _RashifalFormState createState() => _RashifalFormState();
}

class _RashifalFormState extends State<RashifalForm> {
  final TextEditingController dobController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  String result = "";
  bool loading = false;

  Future<void> fetchRashifal() async {
    setState(() => loading = true);
    try {
      final response = await http.post(
        Uri.parse("https://fastapi-cayc.onrender.com/rashifal"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "dob": dobController.text,
          "time": timeController.text,
          "location": locationController.text
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          result = data['rashifal'] ?? "No response from server.";
        });
      } else {
        setState(() {
          result = "Error ${response.statusCode}: ${response.reasonPhrase}";
        });
      }
    } catch (e) {
      setState(() {
        result = "Failed to connect: $e";
      });
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Enter Birth Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: dobController,
              decoration: InputDecoration(labelText: 'Date of Birth (YYYY-MM-DD)'),
            ),
            TextField(
              controller: timeController,
              decoration: InputDecoration(labelText: 'Time (HH:MM) - optional'),
            ),
            TextField(
              controller: locationController,
              decoration: InputDecoration(labelText: 'Location - optional'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: loading ? null : fetchRashifal,
              child: loading
                  ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text("Get Rashifal"),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(result, style: TextStyle(fontSize: 16)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
