import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:star_menu/star_menu.dart';
import 'package:wineandmovie/auth_service.dart';

class WinePage extends StatelessWidget {
  const WinePage({super.key});

  //late Timer timer;

  @override
  Widget build(BuildContext context) {

    final wines = const [
      {'name': 'Pinot Noir', 'year': '2018', 'rating': '4.5'},
      {'name': 'Borolo', 'year': '2020', 'rating': '4.2'},
      {'name': 'Barbaresco', 'year': '2020', 'rating': '5.0'},
      {'name': 'Chardonnay', 'year': '2020', 'rating': '4.2'},
      {'name': 'Merlot', 'year': '2019', 'rating': '4.0'},
    ];

    StarMenuController starMenuController = StarMenuController();

    final upperMenuItems = <Widget>[
      const Text('menu entry 1'),
      const Text('menu entry 2'),
      const Text('menu entry 3'),
      const Text('menu entry 4'),
      const Text('menu entry 5'),
      const Text('menu entry 6'),
    ];

    final otherEntries = <Widget>[
      FloatingActionButton(
        onPressed: () => {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('star menu button clicked'))),
          starMenuController.closeMenu!(),
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add_call),
      ),
      const FloatingActionButton(
        onPressed: null,
        backgroundColor: Colors.indigo,
        child: Icon(Icons.adb),
      ),
      // const FloatingActionButton(
      //   onPressed: null,
      //   backgroundColor: Colors.purple,
      //   child: Icon(Icons.home),
      // ),
      const FloatingActionButton(
        onPressed: null,
        backgroundColor: Colors.blueGrey,
        child: Icon(Icons.delete),
      ),
      FloatingActionButton(
        onPressed: () => {
            AuthService().signOut(),
        },
        backgroundColor: const Color.fromARGB(255, 190, 39, 82),
        child: const Icon(Icons.get_app),
      ).addStarMenu(
        items: upperMenuItems,
        params: StarMenuParameters.dropdown(context),
      ),
    ];
    
    return Scaffold(
      resizeToAvoidBottomInset: true,

      appBar: AppBar(title: const Text('Wines')),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            ListView.builder(
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

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Align(
                alignment: Alignment.bottomRight,
                child: StarMenu(
                  controller: starMenuController,
                  params: StarMenuParameters.arc(
                    ArcType.quarterTopLeft,
                    radiusX: 140,
                    radiusY: 140,
                  ),
                  items: otherEntries,
                  child: const FloatingActionButton(
                    onPressed: null,
                    child: Icon(Icons.balance),
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
