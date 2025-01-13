class Joke {
  final String setup;
  final String punchline;
  final String type;
  bool isFavorite;

  Joke({
    required this.setup,
    required this.punchline,
    required this.type,
    this.isFavorite = false,
  });

  factory Joke.fromJson(Map<String, dynamic> json) {
    return Joke(
      setup: json['setup'],
      punchline: json['punchline'],
      type: json['type'],
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'setup': setup,
      'punchline': punchline,
      'type': type,
      'isFavorite': isFavorite,
    };
  }
}
