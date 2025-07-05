import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class MuhuratWidget extends StatefulWidget {
  final String language;

  MuhuratWidget({required this.language});

  @override
  _MuhuratWidgetState createState() => _MuhuratWidgetState();
}

class _MuhuratWidgetState extends State<MuhuratWidget> {
  String muhurat = '';
  bool visible = true;

  @override
  void initState() {
    super.initState();
    fetchMuhurat();
    Timer.periodic(Duration(minutes: 5), (_) => fetchMuhurat());
  }

  Future<void> fetchMuhurat() async {
    final uri = Uri.parse("https://fastapi-cayc.onrender.com/muhurat?language=${widget.language}");
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          muhurat = data['muhurat'] ?? '';
          visible = true;
        });
        Future.delayed(Duration(seconds: 15), () => setState(() => visible = false));
      }
    } catch (e) {
      setState(() {
        muhurat = 'Failed to load';
        visible = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return visible && muhurat.isNotEmpty
        ? Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(8),
              color: Colors.deepPurple.withOpacity(0.9),
              child: Text(
                muhurat,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          )
        : SizedBox.shrink();
  }
}
