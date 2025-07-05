import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:html' as html;

class PalmReaderScreen extends StatefulWidget {
  @override
  _PalmReaderScreenState createState() => _PalmReaderScreenState();
}

class _PalmReaderScreenState extends State<PalmReaderScreen> {
  String result = '';
  bool loading = false;
  late String language;
  html.File? selectedFile;

  final Map<String, Map<String, String>> i18n = {
    'English': {
      'title': 'Palm Reader',
      'upload': 'Upload Palm Image',
      'submit': 'Analyze',
      'result': 'Prediction',
    },
    'Hindi': {
      'title': 'हस्तरेखा विश्लेषण',
      'upload': 'हथेली छवि अपलोड करें',
      'submit': 'विश्लेषण करें',
      'result': 'भविष्यवाणी',
    },
    'Bhojpuri': {
      'title': 'हथेली पढ़ाई',
      'upload': 'हथेली के फोटो अपलोड करीं',
      'submit': 'जांच करीं',
      'result': 'निष्कर्ष',
    },
    'Telugu': {
      'title': 'చేతి రేఖలు చదవండి',
      'upload': 'చేతి చిత్రం అప్లోడ్ చేయండి',
      'submit': 'విశ్లేషించు',
      'result': 'ఫలితం',
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

  Future<void> uploadPalm() async {
    if (selectedFile == null) return;
    setState(() => loading = true);

    final reader = html.FileReader();
    reader.readAsArrayBuffer(selectedFile!);
    await reader.onLoad.first;

    final data = reader.result as List<int>;

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('https://fastapi-cayc.onrender.com/upload/palm'),
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
              onPressed: loading ? null : uploadPalm,
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
