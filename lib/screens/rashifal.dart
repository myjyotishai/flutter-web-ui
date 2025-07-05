import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RashifalScreen extends StatefulWidget {
  final String language;
  RashifalScreen({required this.language});

  @override
  _RashifalScreenState createState() => _RashifalScreenState();
}

class _RashifalScreenState extends State<RashifalScreen> {
  final TextEditingController dobController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  String result = '';
  String rashiImage = '';
  bool loading = false;

  String extractRashi(String text) {
    final match = RegExp(r'Rashi:\s*(\w+)', caseSensitive: false).firstMatch(text);
    return match != null ? match.group(1)!.toLowerCase() : '';
  }

  String getRashiImage(String rashi) {
    final map = {
      'mesh': 'assets/images/mesh.png',
      'vrishabh': 'assets/images/vrishabh.png',
      'mithun': 'assets/images/mithun.png',
      'karka': 'assets/images/karka.png',
      'simha': 'assets/images/simha.png',
      'kanya': 'assets/images/kanya.png',
      'tula': 'assets/images/tula.png',
      'vrischik': 'assets/images/vrischik.png',
      'dhanu': 'assets/images/dhanu.png',
      'makar': 'assets/images/makar.png',
      'kumbh': 'assets/images/kumbh.png',
      'meen': 'assets/images/meen.png',
    };
    return map[rashi] ?? 'assets/images/default_rashi.png';
  }

  Future<void> fetchRashifal() async {
    setState(() {
      loading = true;
      result = '';
      rashiImage = '';
    });

    final response = await http.post(
      Uri.parse('https://fastapi-cayc.onrender.com/rashifal'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'dob': dobController.text,
        'time': timeController.text,
        'location': locationController.text,
        'language': widget.language
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final output = data['rashifal'] ?? '';
      final rashiName = extractRashi(output);
      setState(() {
        result = output;
        rashiImage = getRashiImage(rashiName);
      });
    } else {
      setState(() {
        result = 'Error ${response.statusCode}: ${response.reasonPhrase}';
      });
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Rashifal (${widget.language})')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: dobController,
              decoration: InputDecoration(labelText: 'Date of Birth (YYYY-MM-DD)'),
            ),
            TextField(
              controller: timeController,
              decoration: InputDecoration(labelText: 'Time (HH:MM, optional)'),
            ),
            TextField(
              controller: locationController,
              decoration: InputDecoration(labelText: 'Location (optional)'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: loading ? null : fetchRashifal,
              child: loading
                  ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator())
                  : Text('Get Rashifal'),
            ),
            SizedBox(height: 20),
            if (rashiImage.isNotEmpty)
              Image.asset(rashiImage, height: 100),
            if (result.isNotEmpty)
              Expanded(
                child: SingleChildScrollView(
                  child: Card(
                    color: Colors.indigo[50],
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(result, style: TextStyle(fontSize: 16)),
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
