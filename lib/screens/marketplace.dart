import 'package:flutter/material.dart';

class MarketplaceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final language = args?['language'] ?? 'English';

    final Map<String, String> labels = {
      'English': 'Astrology Products',
      'Hindi': 'ज्योतिष उत्पाद',
      'Bhojpuri': 'ज्योतिष समान',
      'Telugu': 'జ్యోతిష్యం ఉత్పత్తులు',
    };

    final List<Map<String, String>> products = [
      {
        'title': 'Yellow Sapphire',
        'desc': 'Boosts Jupiter energy, brings wisdom and fortune.',
        'image': 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2d/Sapphire-gem.jpg/320px-Sapphire-gem.jpg',
        'price': '₹4500'
      },
      {
        'title': 'Rudraksha Mala',
        'desc': 'Spiritual healing beads, promotes inner peace.',
        'image': 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/be/Rudraksha_beads.jpg/320px-Rudraksha_beads.jpg',
        'price': '₹900'
      },
      {
        'title': 'Navgrah Yantra',
        'desc': 'Balances planetary energies in your chart.',
        'image': 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e5/Navagraha_Yantra.jpg/320px-Navagraha_Yantra.jpg',
        'price': '₹1200'
      }
    ];

    return Scaffold(
      appBar: AppBar(title: Text(labels[language]!)),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final item = products[index];
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
              leading: Image.network(item['image']!, width: 60, fit: BoxFit.cover),
              title: Text(item['title']!, style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(item['desc']!),
              trailing: Text(item['price']!, style: TextStyle(color: Colors.green)),
              onTap: () {
                // placeholder for buy action
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Buy functionality coming soon!'),
                ));
              },
            ),
          );
        },
      ),
    );
  }
}
