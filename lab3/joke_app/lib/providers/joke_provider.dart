import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../domain/joke.dart';
import '../service/jokes_service.dart';

class JokeProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final JokesService _service;

  JokeProvider(this._service) {
    fetchFavorites();
    fetchJokeTypes();
  }

  final List<Joke> _favorites = [];
  bool isLoading = true;

  List<Joke> get favorites => _favorites;

  List<String> _jokeTypes = [];
  List<String> get jokeTypes => _jokeTypes;

  List<Joke> _jokesByType = [];
  List<Joke> get jokesByType => _jokesByType;

  Joke? _randomJoke;
  Joke? get randomJoke => _randomJoke;

  // Fetch jokes by type
  Future<void> fetchJokesByType(String type) async {
    isLoading = true;
    notifyListeners();
    try {
      _jokesByType = await _service.getJokesByType(type);
    } catch (e) {
      print('Error fetching jokes by type: $e');
    }
    isLoading = false;
    notifyListeners();
  }

  // Fetch random joke
  Future<void> fetchRandomJoke() async {
    isLoading = true;
    notifyListeners();
    try {
      _randomJoke = await _service.getRandomJoke();
    } catch (e) {
      print('Error fetching random joke: $e');
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchJokeTypes() async {
    try {
      _jokeTypes = await _service.getJokeTypes();
    } catch (e) {
      // Handle any exceptions
      print('Error fetching joke types: $e');
    }
    notifyListeners();
  }

  Future<void> fetchFavorites() async {
    try {
      final snapshot = await _firestore.collection('favorites').get();
      _favorites.clear();
      for (var doc in snapshot.docs) {
        final data = doc.data();
        _favorites.add(
          Joke(
            setup: data['setup'],
            punchline: data['punchline'],
            type: data['type'],
            isFavorite: true,
          ),
        );
      }
    } catch (e) {
      print('Error fetching favorites: $e');
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> toggleFavorite(Joke joke) async {
    if (_favorites.any((fav) => fav.setup == joke.setup)) {
      // Remove from favorites
      _favorites.removeWhere((fav) => fav.setup == joke.setup);
      try {
        final snapshot = await _firestore
            .collection('favorites')
            .where('setup', isEqualTo: joke.setup)
            .get();
        for (var doc in snapshot.docs) {
          await _firestore.collection('favorites').doc(doc.id).delete();
        }
      } catch (e) {
        print('Error removing joke from favorites: $e');
      }
    } else {
      // Add to favorites
      _favorites.add(joke);
      try {
        await _firestore.collection('favorites').add(joke.toJson());
      } catch (e) {
        print('Error adding joke to favorites: $e');
      }
    }
    notifyListeners();
  }
}
