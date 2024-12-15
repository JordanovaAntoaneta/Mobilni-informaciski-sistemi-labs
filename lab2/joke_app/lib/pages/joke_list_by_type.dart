import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/joke_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class JokeListByType extends StatelessWidget {
  final String type;

  const JokeListByType({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    Provider.of<JokeProvider>(context, listen: false).fetchJokesByType(type);

    return Scaffold(
      appBar: AppBar(
        title: Text("$type Jokes"),
        backgroundColor: Colors.amber,
      ),
      body: Consumer<JokeProvider>(
        builder: (context, provider, _) {
          return provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
            itemCount: provider.jokesByType.length,
            itemBuilder: (context, index) {
              final joke = provider.jokesByType[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${index + 1}.',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              joke.setup,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              joke.punchline,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}