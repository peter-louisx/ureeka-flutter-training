import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedQuotesPage extends StatefulWidget {
  const SavedQuotesPage({super.key});

  @override
  State<SavedQuotesPage> createState() => SavedQuotesPageState();
}

class SavedQuotesPageState extends State<SavedQuotesPage> {
  List<String> quotes = [];

  @override
  void initState() {
    super.initState();
    loadQuotes();
  }

  Future<void> loadQuotes() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      quotes = prefs.getStringList("savedQuotes") ?? [];
    });
  }

  Future<void> deleteQuote(String quote, String author) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String quotesToRemove = "$quote - $author";
    quotes.remove(quotesToRemove);
    await prefs.setStringList("savedQuotes", quotes);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Successfully removed quote")));

    loadQuotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Saved Quotes"), centerTitle: true),
      body: Column(
        children: [
          Expanded(
            child:
                quotes.isEmpty
                    ? Center(child: Text("There are no quotes saved"))
                    : ListView.builder(
                      itemCount: quotes.length,
                      itemBuilder: (context, index) {
                        final String fullQuote = quotes[index];
                        final List<String> data = fullQuote.split(" - ");
                        final String quote = data[0];
                        final String author = data[1];

                        return Card(
                          child: ListTile(
                            title: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                quote,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(
                                left: 8.0,
                                bottom: 8.0,
                              ),
                              child: Text(
                                "- $author",
                                style: TextStyle(fontSize: 13.0),
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                deleteQuote(quote, author);
                              },
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
