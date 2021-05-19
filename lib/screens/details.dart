import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'home.dart';
import 'package:xml2json/xml2json.dart';
import 'package:flutter_html/flutter_html.dart';

class Details extends StatefulWidget {
  static const routeName = "/details";
  final String id;
  final String semester;
  Details({Key key, this.id, this.semester}) : super(key: key);

  @override
  _DetailsState createState() {
    return _DetailsState(id, semester);
  }
}

class _DetailsState extends State<Details> {
  final String id;
  final String semester;
  int groupnr = 0;
  _DetailsState(this.id, this.semester);

  void _setGroupNr(int nr) {
    setState(() {
      groupnr = nr;
    });
  }

  Future<dynamic> getLV() async {
    var endpointUrl = 'https://m1-ufind.univie.ac.at/courses/';
    var apiUrl = endpointUrl + id + '/' + semester;
    final client = http.Client();
    final response = await client.get(Uri.parse(apiUrl));

    final Xml2Json xml2json = Xml2Json();
    xml2json.parse(response.body);
    var json = xml2json.toGData();
    return jsonDecode(json)['course'];
  }

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
        child: FutureBuilder<dynamic>(
            future: getLV(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              dynamic groupdata;
              if (snapshot.hasData) {
                if (snapshot.data['groups']['group'] is List) {
                  groupdata = snapshot.data['groups']['group'][groupnr];
                } else if (snapshot.data['groups']['group'] is Map) {
                  groupdata = snapshot.data['groups']['group'];
                }
                getcategories(groupdata);
                return Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    child: ListView(children: [
                      //headline
                      Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: Text(
                            snapshot.data['type'][r'$t'] +
                                " " +
                                snapshot.data['longname'][0][r'$t'],
                            style: Theme.of(context).textTheme.headline4,
                            textAlign: TextAlign.center,
                          )),
                      //SPL
                      Text(
                        snapshot.data['offeredby'][r'$t'],
                        style: Theme.of(context).textTheme.subtitle2,
                        textAlign: TextAlign.center,
                      ),
                      //ECTS, Semester, Sprache
                      Container(
                          height: 60,
                          child: Row(children: [
                            Text(
                              "ECTS: " + snapshot.data['ects'][r'$t'],
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            Expanded(
                              child: Text(
                                snapshot.data['when'],
                                style: Theme.of(context).textTheme.subtitle1,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                                child: Text(
                              "Sprache: " +
                                  groupdata['languages']['language']['title'][0]
                                      [r'$t'],
                              style: Theme.of(context).textTheme.subtitle1,
                              textAlign: TextAlign.right,
                            ))
                          ])),
                      //Group Selection
                      if (snapshot.data['groups']['group'] is List)
                        DropdownButton(
                          value: groupnr + 1,
                          items: _getGroups(snapshot.data['groups']['group']),
                          onChanged: (value) {
                            _setGroupNr(value - 1);
                          },
                        ),
                      //expandable tiles
                      ExpansionPanelList(
                        expansionCallback: (int index, bool isExpanded) {
                          setState(() {
                            _categories[index].isExpanded = !isExpanded;
                          });
                        },
                        children: _categories.map<ExpansionPanel>((Item item) {
                          return ExpansionPanel(
                              canTapOnHeader: true,
                              headerBuilder:
                                  (BuildContext context, bool isExpanded) {
                                return ListTile(
                                  title: Text(item.headerValue),
                                );
                              },
                              body: item.expandedWidget,
                              isExpanded: item.isExpanded);
                        }).toList(),
                      ),
                    ]));
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }
}

class Item {
  Item({
    this.expandedWidget,
    this.headerValue,
    this.isExpanded = false,
  });

  Widget expandedWidget;
  String headerValue;
  bool isExpanded;
}

List<Item> _categories = [
  Item(headerValue: 'Prüfungstermine', expandedWidget: null),
  Item(headerValue: 'Lehrende', expandedWidget: null),
  Item(headerValue: 'Termine', expandedWidget: null),
  Item(headerValue: 'Ziele, Inhalte, Methoden', expandedWidget: null),
  Item(headerValue: 'Art der Leistungskontrolle', expandedWidget: null),
  Item(headerValue: 'Mindestanforderung', expandedWidget: null),
  Item(headerValue: 'Prüfungsstoff', expandedWidget: null),
  Item(headerValue: 'Literatur', expandedWidget: null)
];

void getcategories(dynamic data) {
  //Prüfungstermine
  if (data['exams'] != null) {
    if (data['exams']['exam'] is Map) {
      _categories[0].expandedWidget = Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("- " +
                    _changeToReadableDate(data['exams']['exam']['begin']) +
                    '\n')
              ]));
    } else {
      _categories[0].expandedWidget = Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: data['exams']['exam'].map<Widget>((dynamic examdata) {
              return Text("- " + examdata['begin'] + '\n');
            }).toList(),
          ));
    }
  } else {
    _categories[0].expandedWidget = Padding(
        padding: EdgeInsets.all(16),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(
              "Für diese LV gibt es keinen Prüfungstermin. Mehr Informationen bei \"Art der Leistungskontrolle\""),
        ]));
  }
  //Lehrende
  if (data['lecturers']['lecturer'] is Map) {
    _categories[1].expandedWidget = Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text("- " +
              data['lecturers']['lecturer']['firstname'][r'$t'] +
              ' ' +
              data['lecturers']['lecturer']['lastname'][r'$t'] +
              '\n')
        ]));
  } else {
    _categories[1].expandedWidget = Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children:
              data['lecturers']['lecturer'].map<Widget>((dynamic lecturerdata) {
            return Text("- " +
                lecturerdata['firstname'][r'$t'] +
                ' ' +
                lecturerdata['lastname'][r'$t'] +
                '\n');
          }).toList(),
        ));
  }
  //Termine
  if (data['wwlong']['wwevent'] is Map) {
    _categories[2].expandedWidget = Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(
            '- ' +
                _changeToReadableDate(data['wwlong']['wwevent']['begin']) +
                '\n  ' +
                data['wwlong']['wwevent']['location']['address'][r'$t'] +
                '\n',
          )
        ]));
  } else {
    _categories[2].expandedWidget = Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: data['wwlong']['wwevent'].map<Widget>((dynamic termindata) {
            return Text(
              '- ' +
                  _changeToReadableDate(termindata['begin']) +
                  '\n' +
                  termindata['location']['address'][r'$t'] +
                  '\n',
            );
          }).toList(),
        ));

    //Ziele
    if (data['info']['comment'] == null) {
      _categories[3].expandedWidget = Padding(
          padding: EdgeInsets.all(16), child: Text('Keine Informationen'));
    } else {
      if (data['info']['comment'] is List) {
        _categories[3].expandedWidget = Padding(
            padding: EdgeInsets.all(16),
            child: Html(data: data['info']['comment'][0][r'$t']));
      } else {
        _categories[3].expandedWidget = Padding(
            padding: EdgeInsets.all(16),
            child: Html(data: data['info']['comment'][r'$t']));
      }
    }
  }
  if (data['info']['performance'] == null) {
    _categories[4].expandedWidget = Padding(
        padding: EdgeInsets.all(16), child: Text('Keine Informationen'));
  } else {
    if (data['info']['performance'] is List) {
      _categories[4].expandedWidget = Padding(
          padding: EdgeInsets.all(16),
          child: Html(data: data['info']['performance'][0][r'$t']));
    } else {
      _categories[4].expandedWidget = Padding(
          padding: EdgeInsets.all(16),
          child: Html(data: data['info']['performance'][r'$t']));
    }
  }
  if (data['info']['preconditions'] == null) {
    _categories[5].expandedWidget = Padding(
        padding: EdgeInsets.all(16), child: Text('Keine Informationen'));
  } else {
    if (data['info']['preconditions'] is List) {
      _categories[5].expandedWidget = Padding(
          padding: EdgeInsets.all(16),
          child: Html(data: data['info']['preconditions'][0][r'$t']));
    } else {
      _categories[5].expandedWidget = Padding(
          padding: EdgeInsets.all(16),
          child: Html(data: data['info']['preconditions'][r'$t']));
    }
  }
  if (data['info']['examination'] == null) {
    _categories[6].expandedWidget = Padding(
        padding: EdgeInsets.all(16), child: Text('Keine Informationen'));
  } else {
    if (data['info']['examination'] is List) {
      _categories[6].expandedWidget = Padding(
          padding: EdgeInsets.all(16),
          child: Html(data: data['info']['examination'][0][r'$t']));
    } else {
      _categories[6].expandedWidget = Padding(
          padding: EdgeInsets.all(16),
          child: Html(data: data['info']['examination'][r'$t']));
    }
  }
  if (data['info']['literature'] == null) {
    _categories[7].expandedWidget = Padding(
        padding: EdgeInsets.all(16), child: Text('Keine Informationen'));
  } else {
    if (data['info']['literature'] is List) {
      _categories[7].expandedWidget = Padding(
          padding: EdgeInsets.all(16),
          child: Html(data: data['info']['literature'][0][r'$t']));
    } else {
      _categories[7].expandedWidget = Padding(
          padding: EdgeInsets.all(16),
          child: Html(
            data: data['info']['literature'][r'$t'],
          ));
    }
  }
}

List<DropdownMenuItem> _getGroups(dynamic groups) {
  List<DropdownMenuItem> out = [];
  for (int i = 1; i <= groups.length; i++) {
    out.add(DropdownMenuItem(
      child: Text('Gruppe ' + i.toString()),
      value: i,
    ));
  }
  return out;
}

String _changeToReadableDate(String input) {
  final dateTime = DateTime.parse(input);
  final format = DateFormat('d.M.y HH:mm a');
  final clockString = format.format(dateTime);
  return clockString;
}
