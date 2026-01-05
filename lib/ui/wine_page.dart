import 'package:flutter/material.dart';

class WinePage extends StatelessWidget {
  const WinePage({super.key});

  @override
  Widget build(BuildContext context) {
    final wines = const [
      {'name': 'Pinot Noir', 'year': '2018', 'rating': '4.5'},
      {'name': 'Chardonnay', 'year': '2020', 'rating': '4.2'},
      {'name': 'Merlot', 'year': '2019', 'rating': '4.0'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Wines')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: wines.length,
        itemBuilder: (context, index) {
          final w = wines[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              leading: const Icon(Icons.local_bar),
              title: Text(w['name']!),
              subtitle: Text('${w['year']} • Rating: ${w['rating']}'),
            ),
          );
        },
      ),
    );
  }
}
