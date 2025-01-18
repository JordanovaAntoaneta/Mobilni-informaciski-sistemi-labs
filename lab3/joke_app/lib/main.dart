import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:joke_app/pages/favorites_screen.dart';
import 'package:joke_app/pages/random_joke.dart';
import 'package:joke_app/service/firebase_api.dart';
import 'package:joke_app/service/jokes_service.dart';
import 'package:provider/provider.dart';
import 'providers/joke_provider.dart';
import 'pages/joke_list_by_type.dart';
import 'widgets/joke_card.dart';
import 'package:google_fonts/google_fonts.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyAkKvDU1dHydrFm57L4AzZGKk9oyVlIpY8',
        appId: '1:295295855872:android:e48ef8e36c1ac3171e17e5',
        messagingSenderId: '295295855872',
        projectId: 'joke-app-lab3',
        storageBucket: 'joke-app-lab3.firebasestorage.app',
      )
  );
  //await
  FirebaseApi().initNotifications();
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
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Jokes App',
        theme: ThemeData(
          primarySwatch: Colors.amber,
          textTheme: GoogleFonts.snigletTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        home: const HomePage(),
        routes: {
          RandomJokeScreen.route: (context) => const RandomJokeScreen(),
        }
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
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritesScreen()),
              );
            },
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            // Random Joke Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const RandomJokeScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  padding: const EdgeInsets.symmetric(
                    vertical: 20.0,
                    horizontal: 30.0,
                  ),
                  textStyle: GoogleFonts.sniglet(
                    textStyle: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                ),
                child: const Text("Random Joke of the Day"),
              ),
            ),
            // Joke Types List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
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
          ],
        ),
      ),
    );
  }
}
