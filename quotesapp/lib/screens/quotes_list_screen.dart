import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quotesapp/screens/saved_quotes_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class QuoteHomePage extends StatefulWidget {
  const QuoteHomePage({super.key});

  @override
  State<QuoteHomePage> createState() => _QuoteHomePageState();
}

class _QuoteHomePageState extends State<QuoteHomePage> {
  String quote = " ";
  String author = " ";

  @override
  void initState() {
    super.initState();
    fetchQuote();
  }

  Future<void> fetchQuote() async {
    final response = await http.get(
      Uri.parse("https://zenquotes.io/api/random"),
    );

    final List<dynamic> data = jsonDecode(response.body);

    setState(() {
      quote = data[0]['q'];
      author = data[0]['a'];
    });
  }

  Future<void> saveQuote() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String fullQuote = "$quote - $author";
    List<String> currentQuotes = prefs.getStringList("savedQuotes") ?? [];

    if (!currentQuotes.contains(fullQuote)) {
      currentQuotes.add(fullQuote);
      await prefs.setStringList("savedQuotes", currentQuotes);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Successfully saved \n$fullQuote")),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Quote already exists!")));

      fetchQuote();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Random Quotes Generator"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SavedQuotesPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Text(
                        "\"$quote\"",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          "- $author",
                          style: TextStyle(fontSize: 15.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: const Text("Save Quote"),
                    onPressed: () {
                      saveQuote();
                    },
                  ),
                  const SizedBox(width: 10.0),
                  ElevatedButton(
                    child: const Text("Randomize Quote"),
                    onPressed: () {
                      fetchQuote();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
