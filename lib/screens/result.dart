import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home.dart';
import 'details.dart';
import 'package:xml2json/xml2json.dart';

class SearchResult extends StatefulWidget {
  static const routeName = "/result";
  final String input;
  final String type;
  final String term;
  final String study;

  //Konstruktor um Namen vom HomeScreen zu übernehmen
  SearchResult({Key key, this.input, this.type, this.term, this.study})
      : super(key: key);

  @override
  _SearchResultState createState() {
    return _SearchResultState(input, type, term, study);
  }
}

class _SearchResultState extends State<SearchResult> {
  final String input;
  final String type;
  final String term;
  final String study;
  _SearchResultState(this.input, this.type, this.term, this.study);

  String filtertype = "";
  String filterterm = "";
  String filterstudy = "";
  String emptyinput = "";

  Future<List<dynamic>> fetchLV() async {
    var endpointUrl = 'https://m1-ufind.univie.ac.at/courses/';
    var queryParams = {
      'query': input,
    };
    if (input == null || input.isEmpty) {
      emptyinput = "=";
    }
    String queryString = Uri(queryParameters: queryParams).query;
    if (type != null && type != "alle LV-Typen") {
      filtertype = "%20ctype%3A$type";
    }
    if (term != null && term != "alle Semester") {
      filterterm = "%20%20%2B$term";
    }
    if (study != null) {
      filterstudy = study;
    }
    var apiUrl = endpointUrl +
        '?' +
        queryString +
        emptyinput +
        filterstudy +
        filtertype +
        ' c%3A50' +
        filterterm;
    //print(apiUrl);
    final client = http.Client();
    final response = await client.get(apiUrl);

    final Xml2Json xml2json = Xml2Json();
    xml2json.parse(response.body);
    var json = xml2json.toGData();
    //debugPrint(json);
    return jsonDecode(json)['result']['course'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/ufind.png', fit: BoxFit.cover, height: 40),
        //Button um zurück auf den HomeScreen zu kommen
        actions: [
          IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.of(context)
                    .pushReplacementNamed(HomeScreen.routeName);
              })
        ],
      ),
      body: Container(
        color: Colors.lightBlue[50],
        child: FutureBuilder<List<dynamic>>(
          future: fetchLV(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: CircleAvatar(
                                radius: 30,
                                child:
                                    Text(snapshot.data[index]['type'][r'$t'])),
                            title: Text(
                                snapshot.data[index]['longname'][0][r'$t']),
                            subtitle: Text(snapshot.data[index]['offeredby']
                                    [r'$t'] +
                                '\n' +
                                'LV-Nummer: ' +
                                snapshot.data[index][
                                    'id']), //['chapters']['chapter'][0]['category'][0][r'$t'] + "  " + snapshot.data[index]['id']),
                            trailing: Text(snapshot.data[index]['when']),
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Details(
                                      id: snapshot.data[index]['id'],
                                      semester: snapshot.data[index]['when']),
                                )),
                          ),
                        ],
                      ),
                    );
                  });
              //Ladebildschirm währen Daten abgerufen werden
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
