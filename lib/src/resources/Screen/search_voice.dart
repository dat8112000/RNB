import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

class searchVoice extends StatefulWidget {
  const searchVoice({Key? key}) : super(key: key);

  @override
  _searchVoiceState createState() => _searchVoiceState();
}

class _searchVoiceState extends State<searchVoice> {
  @override
  String result1 = 'Result 1';
  String result2 = 'Result 2';
  String result3 = 'Result 3';
  String linkRequest = "https://timkiem.vnexpress.net/?q=";
  var document;
  var responseArticle;
  var chuoi = "";
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    extractData();
  }

  void extractData() async {
    final response = await http.Client()
        .get(Uri.parse('https://timkiem.vnexpress.net/?q=báo+thể+thao'));
    if (response.statusCode == 200) {
      setState(() {
        document = parser.parse(response.body);
        responseArticle = document
            .getElementsByClassName('width_common list-news-subfolder')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: document == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: responseArticle.children.length,
                itemBuilder: (context, int index) => SizedBox(
                  child: Card(
                    child: ListTile(
                      title: Text(responseArticle
                          .children[index].children[1].text.trim()
                          ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
