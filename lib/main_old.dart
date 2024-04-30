import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Entry point for the app
void main() {
  runApp(MyApp());
}
/// the Application. A class that sets up the whole application
/// Extends widget which are the building blocks all flutter apps
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}
/// Helps in managing the app's state and refresh incase of new state
/// myAppstate defines the data the app needs to function
/// the state class extends change notifier meaning that it can notify others of its own changes eg
/// if the word pair changes, some widgets in the app need to know and act accordingly
class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
   /// this method chnages the current state with a new random pair
  void getNext() {
    current = WordPair.random();
    /// notifys listeners of its change
    notifyListeners();
  }
  /// logic for liking and unliking, if a wordpair is liked, add it to the list of likes 
  /// if the word is unliked, remove it from the list of likes
  ///  also specified that the list can only ever contain word pairs: <WordPair>[], using generics
  var favorites = <WordPair>[];

/// also added a new method, toggleFavorite(), which either removes the current word pair from the list of favorites (if it's already there), or adds it (if it isn't there yet). In either case, the code calls notifyListeners(); afterwards.
  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
 
}
/// every widger returns a build() method thats automatically called every time
/// the widget's state changes, so that the widget is always up to date
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /// myhomepage tracks chnages to the current app's state using watch method
    var appState = context.watch<MyAppState>();
    var pair = appState.current;
    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }
    /// every build() method must return a widget or more. In our case the top-level widget is scaffold. 
    /// Column is one of the most basic layouts in flutter. 
    /// It takes any number of children and puts them in a column from top to bottom. 
    return Scaffold(
      body: Center(
        child: Column(
          /// vertically centers column contents
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BigCard(pair: pair),
            /// sizedBox in flutter is used to create visual gaps between elements
            SizedBox(height: 10),
            Row(
               mainAxisSize: MainAxisSize.min, 
              children: [
                
                ElevatedButton.icon(
                  onPressed: () {
                    appState.toggleFavorite();
                  },
                  icon: Icon(icon),
                  label: Text('Like'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    /// the getNext method is called on button press
                    appState.getNext();
                    print('button pressed!');
                  },
                  child: Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
           pair.asLowerCase,
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}",
        ),
      ),
    );
  }
}
