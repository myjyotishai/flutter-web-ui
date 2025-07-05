import 'package:flutter/material.dart';

class MarketplaceScreen extends StatelessWidget {
  final String language;

  MarketplaceScreen({required this.language});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Marketplace ($language)")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Explore Astrological Services",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.book_online),
                    title: Text("Book a Kundli Reading"),
                    subtitle: Text("Expert astrologer available for live sessions"),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {}, // Future action
                  ),
                  ListTile(
                    leading: Icon(Icons.photo),
                    title: Text("Palm Reading Image Analysis"),
                    subtitle: Text("Upload and receive insights"),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.pushNamed(context, '/palm');
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.face),
                    title: Text("Face Reading AI"),
                    subtitle: Text("Discover what your expressions reveal"),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.pushNamed(context, '/face');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
