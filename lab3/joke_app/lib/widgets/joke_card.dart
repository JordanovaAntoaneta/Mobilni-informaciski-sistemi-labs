import 'package:flutter/material.dart';

class JokeCard extends StatelessWidget {
  final String type;
  final VoidCallback onTap;

  const JokeCard({super.key, required this.type, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      color: Colors.amber,
      child: ListTile(
        title: Text(type),
        onTap: onTap,
      ),
    );
  }
}
