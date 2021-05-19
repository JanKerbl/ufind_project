import 'package:flutter/material.dart';
import 'package:ufind_project/screens/result.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/home";

  @override
  _HomeScreenState createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final _nameController = TextEditingController();

  String termChoose;
  List termItem = ["alle Semester", "Aktuelles Semester", "Letztes Semester"];

  String typeChoose;
  List typeItem = [
    "alle LV-Typen",
    "VU",
    "VO",
    "UE",
    "SE",
    "KU",
    "PR",
    "PS",
    "LP",
    "PUE"
  ];

  String studyChoose;
  List studyItem = [
    "Alle Studien",
    "Besondere Lehrangebote",
    "Katholische Theologie",
    "Evangelische Theologie",
    "Rechtswissenschaften",
    "Wirtschaftswissenschfaten",
    "Informatik & Wirtschaftsinformatik",
    "Ägyptologie, Judaistik, Urgeschichte und Historische Archäologie",
    "Geschichte",
    "Kunstgeschichte und Europäische Ethnologie",
    "Altertumswissenschaften",
    "Deutsche Philologie",
    "Romanistik",
    "Anglistik",
    "Finno-Ugristik, Nederlandistik, Skandinavistik und Vergleichende Literaturwissenschaft",
    "Orientalistik, Afrikanistik, Indologie und Tibetologie",
    "Ostasienwissenschaften",
    "Musikwissenschaft und Sprachwissenschaft",
    "Theater-, Film- und Medienwissenschaft",
    "Philosophie",
    "Bildungswissenschaft",
    "Psychologie",
    "Politikwissenschaft",
    "Publizistik- und Kommunikationswissenschaft",
    "Soziologie",
    "Kultur- und Sozialanthropologie",
    "Mathematik",
    "Physik",
    "Chemie",
    "Erdwissenschaften, Meteorologie-Geophysik und Astronomie",
    "Geographie",
    "Biologie",
    "Molekulare Biologie",
    "Pharmazie",
    "Ernährungswissenschaft",
    "Translationswissenschaft",
    "Sportwissenschaft",
    "Doktoratsstudium Katholische Theologie",
    "Doktoratsstudium Evangelische Theologie",
    "Doktoratsstudium Rechtswissenschaften",
    "Doktoratsstudium Wirtschaftswissenschaften",
    "Doktoratsstudium Sozialwissenschaften",
    "Historisch-Kulturwissenschaftliches Doktoratsstudium",
    "Philologisch-Kulturwissenschaftliches Doktoratsstudium",
    "Doktoratsstudium Philosophie und Bildungswissenschaft",
    "Doktoratsstudium Naturwissenschaften und technische Wissenschaften",
    "Doktoratsstudium Geowissenschaften, Geographie und Astronomie",
    "Doktoratsstudium Psychologie",
    "Doktoratsstudium Lebenswissenschaften",
    "Slawistik",
    "LehrerInnenbildung",
    "Doktoratsstudium Informatik",
    "Doktoratsstudium Mathematik",
    "Doktoratsstudium Physik",
    "Doktoratsstudium Chemie",
    "Doktoratsstudium Psychologie und Biologie mit Schwerpunkt CoBeNe",
    "Doktoratsstudium Biologie mit Schwerpunkt Ökologie und Evolution",
    "Doktoratsstudium Molekulare Biologie",
    "Doktoratsstudium Biologie mit Schwerpunkt Mikrobiologie und Umweltsystemwissenschaft",
    "Doktoratsstudium Pharmazie, Ernährungswissenschaften und Sportwissenschaft"
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:
              Image.asset('assets/ufind.png', fit: BoxFit.cover, height: 40)),
      body: Container(
        //color: Colors.lightBlue[50],
        width: 350,
        height: 280,
        margin: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(8)),
                  child: DropdownButton(
                    hint: Text("  LV-Typ filtern"),
                    underline: SizedBox(),
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 35,
                    value: typeChoose,
                    onChanged: (newValue) {
                      setState(() {
                        typeChoose = newValue;
                      });
                    },
                    items: typeItem.map((valueItem) {
                      return DropdownMenuItem(
                        value: valueItem,
                        child: Text(valueItem),
                      );
                    }).toList(),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(8)),
                  child: DropdownButton(
                    hint: Text("  Semester filtern"),
                    underline: SizedBox(),
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 35,
                    value: termChoose,
                    onChanged: (newValue) {
                      setState(() {
                        termChoose = newValue;
                      });
                    },
                    items: termItem.map((valueItem) {
                      return DropdownMenuItem(
                        value: valueItem,
                        child: Text(valueItem),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: 350,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(8)),
                  child: DropdownButton(
                    isExpanded: true,
                    hint: Text("  Studium filtern"),
                    underline: SizedBox(),
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 35,
                    value: studyChoose,
                    onChanged: (newValue) {
                      setState(() {
                        studyChoose = newValue;
                      });
                    },
                    items: studyItem.map((valueItem) {
                      return DropdownMenuItem(
                        value: valueItem,
                        child: Text(valueItem),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Lehrveranstaltung, SPL-Nummer, ...",
              ),
              controller: _nameController,
            ),
            ElevatedButton(
              child: Text(
                "Suchen",
              ),
              onPressed: () {
                _sendData(context);
              },
            ),
            Center(
                child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/vvz');
              },
              child: Text('VVZ'),
            ))
          ],
        ),
      ),
    );
  }

  //Navigator schickt eingegebenen Namen zur nächsten Seite
  void _sendData(BuildContext context) {
    String name = _nameController.text;
    String termC = termChoose;
    String spl;
    if (termChoose == "Aktuelles Semester") {
      termC = "ct";
    }
    if (termChoose == "Letztes Semester") {
      termC = "lt";
    }
    if (studyChoose != null && studyChoose != "Alle Studien") {
      for (var i = 0; i < studyItem.length; i++) {
        if (studyItem[i] == studyChoose) {
          spl = " spl" + (i - 1).toString();
        }
      }
    }

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchResult(
              input: name, type: typeChoose, term: termC, study: spl),
        ));
  }
}
