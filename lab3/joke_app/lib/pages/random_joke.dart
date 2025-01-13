import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RandomJokeScreen extends StatefulWidget {
  const RandomJokeScreen({super.key});

  @override
  _RandomJokeScreenState createState() => _RandomJokeScreenState();
}

class _RandomJokeScreenState extends State<RandomJokeScreen> {
  bool isLoading = true;
  String setup = "";
  String punchline = "";

  @override
  void initState() {
    super.initState();
    fetchRandomJoke();
  }

  Future<void> fetchRandomJoke() async {
    final response = await http.get(Uri.parse('https://official-joke-api.appspot.com/random_joke'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        setup = data['setup'];
        punchline = data['punchline'];
        isLoading = false;
      });
    } else {
      setState(() {
        setup = "Failed to load joke.";
        punchline = "";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Random Joke of the Day"),
        backgroundColor: Colors.amber,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  setup,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  punchline,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
