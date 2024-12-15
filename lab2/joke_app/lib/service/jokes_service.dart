import 'package:http/http.dart' as http;
import 'dart:convert';
import '../domain/joke.dart';

class JokesService {
  final String _baseUrl = "https://official-joke-api.appspot.com";

  Future<List<String>> getJokeTypes() async {
    final response = await http.get(Uri.parse("$_baseUrl/types"));
    if (response.statusCode == 200) {
      return List<String>.from(json.decode(response.body));
    } else {
      throw Exception("Failed to load joke types");
    }
  }

  Future<List<Joke>> getJokesByType(String type) async {
    final response =
    await http.get(Uri.parse("$_baseUrl/jokes/$type/ten"));
    if (response.statusCode == 200) {
      final List jokesJson = json.decode(response.body);
      return jokesJson.map((e) => Joke.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load jokes");
    }
  }

  Future<Joke> getRandomJoke() async {
    final response =
    await http.get(Uri.parse("$_baseUrl/random_joke"));
    if (response.statusCode == 200) {
      return Joke.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load random joke");
    }
  }
}
