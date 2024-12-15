import 'package:flutter/material.dart';
import 'package:joke_app/service/jokes_service.dart';
import 'package:provider/provider.dart';
import 'providers/joke_provider.dart';
import 'pages/joke_list_by_type.dart';
import 'widgets/joke_card.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => JokeProvider(JokesService())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Jokes App',
        theme: ThemeData(
          primarySwatch: Colors.amber,
          textTheme: GoogleFonts.snigletTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<JokeProvider>(context, listen: false).fetchJokeTypes();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<JokeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Joke Types"),
        backgroundColor: Colors.amber,
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: provider.jokeTypes.length,
        itemBuilder: (context, index) {
          final type = provider.jokeTypes[index];
          return JokeCard(
            type: type,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => JokeListByType(type: type),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
