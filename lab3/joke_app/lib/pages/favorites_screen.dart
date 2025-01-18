import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/joke_provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<JokeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorite Jokes"),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: provider.favorites.length,
        itemBuilder: (context, index) {
          final joke = provider.favorites[index];
          return Card(
            child: ListTile(
              title: Text(joke.setup),
              subtitle: Text(joke.punchline),
              trailing: IconButton(
                icon: Icon(
                  joke.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: joke.isFavorite ? Colors.red : Colors.grey,
                ),
                onPressed: () {
                  provider.toggleFavorite(joke);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
