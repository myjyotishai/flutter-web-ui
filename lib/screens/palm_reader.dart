import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/material.dart';

class PalmReaderScreen extends StatefulWidget {
  @override
  _PalmReaderScreenState createState() => _PalmReaderScreenState();
}

class _PalmReaderScreenState extends State<PalmReaderScreen> {
  String result = '';
  bool loading = false;
  String language = 'English';
  String? uploadedImageUrl;

  void uploadPalmImage() async {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    language = args?['language'] ?? 'English';

    final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((e) async {
      final file = uploadInput.files!.first;
      final reader = html.FileReader();

      reader.readAsDataUrl(file); // For image preview
      reader.onLoad.first.then((_) {
        setState(() {
          uploadedImageUrl = reader.result as String?;
        });
      });

      final readerBytes = html.FileReader();
      readerBytes.readAsArrayBuffer(file);
      await readerBytes.onLoad.first;

      final formData = html.FormData();
      formData.appendBlob('file', file, file.name);
      formData.append('language', language);

      final request = html.HttpRequest();
      setState(() => loading = true);
      try {
        request.open('POST', 'https://fastapi-cayc.onrender.com/upload/palm');
        request.send(formData);
        await request.onLoadEnd.first;

        if (request.status == 200) {
          final Map<String, dynamic> jsonResponse = json.decode(request.responseText!);
          setState(() {
            result = jsonResponse['summary'] ?? 'No result returned.';
          });
        } else {
          setState(() {
            result = 'Error: ${request.statusText}';
          });
        }
      } catch (e) {
        setState(() {
          result = 'Upload failed: $e';
        });
      } finally {
        setState(() => loading = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Palm Reader")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: loading ? null : uploadPalmImage,
              icon: Icon(Icons.file_upload),
              label: Text("Upload Palm Image"),
            ),
            SizedBox(height: 20),
            if (loading) CircularProgressIndicator(),
            if (!loading && result.isNotEmpty)
              Card(
                color: Colors.purple[50],
                elevation: 4,
                margin: EdgeInsets.all(12),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      if (uploadedImageUrl != null)
                        Image.network(uploadedImageUrl!, height: 160),
                      SizedBox(height: 10),
                      Text(
                        result,
                        style: TextStyle(fontSize: 16, color: Colors.deepPurple[900]),
                      ),
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
