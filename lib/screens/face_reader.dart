import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:html' as html;

class FaceReaderScreen extends StatefulWidget {
  @override
  _FaceReaderScreenState createState() => _FaceReaderScreenState();
}

class _FaceReaderScreenState extends State<FaceReaderScreen> {
  String result = '';
  bool loading = false;
  late String language;
  html.File? selectedFile;

  final Map<String, Map<String, String>> i18n = {
    'English': {
      'title': 'Face Reader',
      'upload': 'Upload Face Image',
      'submit': 'Analyze',
      'result': 'Personality Analysis',
    },
    'Hindi': {
      'title': 'चेहरा विश्लेषण',
      'upload': 'चेहरे की छवि अपलोड करें',
      'submit': 'विश्लेषण करें',
      'result': 'व्यक्तित्व विश्लेषण',
    },
    'Bhojpuri': {
      'title': 'चेहरा पढ़ाई',
      'upload': 'चेहरा के फोटो अपलोड करीं',
      'submit': 'जांच करीं',
      'result': 'व्यक्तित्व विश्लेषण',
    },
    'Telugu': {
      'title': 'ముఖం విశ్లేషణ',
      'upload': 'ముఖ చిత్రాన్ని అప్లోడ్ చేయండి',
      'submit': 'విశ్లేషించు',
      'result': 'వ్యక్తిత్వ విశ్లేషణ',
    },
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    language = args?['language'] ?? 'English';
  }

  void pickFile() {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement(); 

    uploadInput.accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      if (files != null && files.isNotEmpty) {
        setState(() {
          selectedFile = files.first;
        });
      }
    });
  }

  Future<void> uploadFace() async {
    if (selectedFile == null) return;
    setState(() => loading = true);

    final reader = html.FileReader();
    reader.readAsArrayBuffer(selectedFile!);
    await reader.onLoad.first;

    final data = reader.result as List<int>;

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('https://fastapi-cayc.onrender.com/upload/face'),
    );
    request.files.add(http.MultipartFile.fromBytes(
      'file',
      data,
      filename: selectedFile!.name,
    ));
    request.fields['language'] = language;

    final response = await request.send();
    final respStr = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final decoded = json.decode(respStr);
      setState(() {
        result = decoded['result'] ?? 'No result';
      });
    } else {
      setState(() {
        result = "Upload failed: ${response.statusCode}";
      });
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final t = i18n[language]!;

    return Scaffold(
      appBar: AppBar(title: Text(t['title']!)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: pickFile,
              child: Text(t['upload']!),
            ),
            if (selectedFile != null) Text(selectedFile!.name),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: loading ? null : uploadFace,
              child: loading ? CircularProgressIndicator() : Text(t['submit']!),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  result.isEmpty ? '' : "${t['result']}: \n\n$result",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
