import 'package:flutter/material.dart';
import '../domain/joke.dart';
import '../service/jokes_service.dart';

class JokeProvider with ChangeNotifier {
  final JokesService _service;

  JokeProvider(this._service);

  List<String> _jokeTypes = [];
  List<String> get jokeTypes => _jokeTypes;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Joke> _jokesByType = [];
  List<Joke> get jokesByType => _jokesByType;

  Joke? _randomJoke;
  Joke? get randomJoke => _randomJoke;

  Future<void> fetchJokeTypes() async {
    _isLoading = true;
    notifyListeners();
    _jokeTypes = await _service.getJokeTypes();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchJokesByType(String type) async {
    _isLoading = true;
    notifyListeners();
    _jokesByType = await _service.getJokesByType(type);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchRandomJoke() async {
    _isLoading = true;
    notifyListeners();
    _randomJoke = await _service.getRandomJoke();
    _isLoading = false;
    notifyListeners();
  }

  final List<Joke> _favorites = [];
  List<Joke> get favorites => _favorites;

  void toggleFavorite(Joke joke) {
    joke.isFavorite = !joke.isFavorite;
    if (joke.isFavorite) {
      _favorites.add(joke);
    } else {
      _favorites.remove(joke);
    }
    notifyListeners();
  }
}
