import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RashifalScreen extends StatefulWidget {
  @override
  _RashifalScreenState createState() => _RashifalScreenState();
}

class _RashifalScreenState extends State<RashifalScreen> {
  final TextEditingController dobController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  String result = "";
  bool loading = false;
  String language = 'English';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    language = args?['language'] ?? 'English';
  }

  Future<void> fetchRashifal() async {
    setState(() => loading = true);
    try {
      final response = await http.post(
        Uri.parse("https://fastapi-cayc.onrender.com/rashifal"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "dob": dobController.text,
          "time": timeController.text,
          "location": locationController.text,
          "language": language
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
