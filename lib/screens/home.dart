import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedLanguage = 'English';
  final List<String> _languages = ['English', 'Hindi', 'Bhojpuri', 'Telugu'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('JyotishAI')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Select Language:', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            DropdownButton<String>(
              value: _selectedLanguage,
              isExpanded: true,
              onChanged: (value) {
                setState(() => _selectedLanguage = value!);
              },
              items: _languages.map((lang) {
                return DropdownMenuItem<String>(
                  value: lang,
                  child: Text(lang),
                );
              }).toList(),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(
                context,
                '/rashifal',
                arguments: {'language': _selectedLanguage},
              ),
              child: Text('Get Rashifal'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(
                context,
                '/palm',
                arguments: {'language': _selectedLanguage},
              ),
              child: Text('Palm Reading'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(
                context,
                '/face',
                arguments: {'language': _selectedLanguage},
              ),
              child: Text('Face Analysis'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(
                context,
                '/marketplace',
                arguments: {'language': _selectedLanguage},
              ),
              child: Text('Marketplace'),
            ),
            SizedBox(height: 40),
            Text('Selected Language: $_selectedLanguage', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
