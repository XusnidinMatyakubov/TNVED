import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../modal/TnvedCode.dart';
import 'ApiUrl.dart';

class RandomWordsState extends State<RandomWords> {
  final List<TnvedCode> _list = <TnvedCode>[];
  final List<TnvedCode> _serach = [];

  var _postJson = [];
  var loading = false;

  void fetchData() async {
    setState(() {
      loading = true;
    });
    _list.clear();
    final url = Uri.parse(apiUrl);
    try {
      final response = await http.get(url, headers: {
        "Accept": "application/json",
        "Access-Control_Allow_Origin": "*",
      });
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          for (var i in data) {
            _list.add(TnvedCode.formJson(i));
            loading = false;
          }
        });
      }
    } catch (err) {}
  }

  TextEditingController controller = new TextEditingController();

  onSearch(String text) async {
    _serach.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    _list.forEach((f) {
      if (f.id.contains(text)) _serach.add(f);
    });
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  final Set<TnvedCode> _saved = <TnvedCode>{};
  final _biggerFont = const TextStyle(fontSize: 18.0);

  Widget _buildSuggestions() {
    return ListView.builder(
        itemCount: _list.length,
        itemBuilder: (context, i) {
          final l = _list[i];
          final alreadySaved = _saved.contains(l);
          return ListTile(
            title: Text(
              "Salom",
              style: _biggerFont,
            ),
            trailing: Icon(
              alreadySaved ? Icons.star_outlined : Icons.star_border_outlined,
              color: alreadySaved ? Colors.red : null,
            ),
            onTap: () {
              setState(() {
                if (alreadySaved) {
                  _saved.remove(l);
                } else {
                  _saved.add(l);
                }
              });
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Startup Name Generator'),
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final tiles = _saved.map(
            (TnvedCode tnvedCode) {
              return ListTile(
                title: Text(
                  "tnvedCode.name",
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          return Scaffold(
            appBar: AppBar(
              title: const Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}
