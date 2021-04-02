import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext ctx) {
    return MaterialApp(
      title: "Name generator",
      home: RandomWords(),
      theme:
          ThemeData(primaryColor: Colors.black, backgroundColor: Colors.grey),
    );
  }
}

//just makes the widget
class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

//the actual logic goes here
class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[]; //<WordPair>[] == List<WordPair>()
  final _saved = <WordPair>{}; //set so only has unique items
  final _biggerFont = TextStyle(fontSize: 18);

  Widget _buildSuggestions() {
    return ListView.builder(
      padding: EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        // if (i.isOdd) return Divider();

        final index = i;
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[index]);
      },
    );
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return ListTile(
      // tileColor: Colors.amber[100],
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final tiles = _saved.map(
            (WordPair pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
                trailing: Icon(
                  _saved.contains(pair)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: _saved.contains(pair) ? Colors.red : null,
                ),
                onTap: () {
                  setState(() {
                    if (_saved.contains(pair)) {
                      _saved.remove(pair);
                    } else {
                      _saved.add(pair);
                    }
                  });
                },
              );
            },
          );
          //divided includes the text
          final divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          return Scaffold(
            appBar: AppBar(
              title: Text('Saved Suggestions'),
            ),
            body: Center(child: ListView(children: divided)),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Name generator"),
        actions: [
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
          IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  _saved.clear();
                });
              })
        ],
      ),
      body: _buildSuggestions(),
    );
  }
}
