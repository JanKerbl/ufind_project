import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home.dart';

class VvzScreen extends StatefulWidget {
  static const routeName = "/vvz";

  VvzScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _VvzScreenState createState() => new _VvzScreenState();
}

class _VvzScreenState extends State<VvzScreen> {
  Future<List<Vvz>> _getVvz() async {
    var data = await http
        .get("https://raw.githubusercontent.com/JanKerbl/json/main/vvz.json");
    List<dynamic> jsonData = jsonDecode(data.body);
    List<Vvz> vvz = jsonData.map((jsonData) => Vvz.fromJson(jsonData)).toList();

    return vvz;
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
          child: FutureBuilder<List<Vvz>>(
              future: _getVvz(),
              builder: (context, data) {
                if (data.connectionState != ConnectionState.waiting &&
                    data.hasData) {
                  var vvzList = data.data;
                  return ListView.builder(
                      itemCount: vvzList.length,
                      itemBuilder: (context, index) {
                        var vvzData = vvzList[index];
                        return ExpansionTile(
                          key: Key("$index"),
                          title: Text("SPL: " + index.toString() ?? "",
                              style: TextStyle(fontSize: 20)),
                          subtitle: Text(vvzData.spl ?? ""),
                          children: <Widget>[
                            Container(
                              color: Colors.grey.withAlpha(55),
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    ListView.builder(
                                        physics: ClampingScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: vvzData.classes.length,
                                        itemBuilder: (context, index) {
                                          return ExpansionTile(
                                              key: Key("$index"),
                                              title:
                                                  Text(vvzData.classes[index]));
                                        }),
                                  ],
                                ),
                              ),
                            )
                          ],
                        );
                      });
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final Vvz vvz;

  DetailPage(this.vvz);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: Text(vvz.spl),
    ));
  }
}

List<Vvz> vvzFromJson(String str) =>
    List<Vvz>.from(json.decode(str).map((x) => Vvz.fromJson(x)));

class Vvz {
  Vvz({
    this.spl,
    this.classes,
  });

  String spl;
  dynamic classes;

  factory Vvz.fromJson(Map<String, dynamic> json) => Vvz(
        spl: json["spl"],
        classes: json["classes"],
      );
}
