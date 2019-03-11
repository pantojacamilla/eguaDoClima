import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:egua_do_clima/util/utils.dart' as util;


class EguaDoClima extends StatefulWidget {
  @override
  _EguaDoClimaState createState() => new _EguaDoClimaState();
}

class _EguaDoClimaState extends State<EguaDoClima> {

  String _cityEntered;

  Future _goToNextScreen(BuildContext context) async {
    Map results = await Navigator
        .of(context)
        .push(new MaterialPageRoute<Map>(builder: (BuildContext context) {
      return new ChangeCity();
    }));

    if ( results != null && results.containsKey('enter')) {
      _cityEntered = results['enter'];
    }
  }

  void showStuff() async {
    Map data = await getWeather(util.appId, util.defaultCity);
    print(data.toString());
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(''
          'Égua do Clima',
          style: new TextStyle(fontSize: 30),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.menu),
              onPressed: () {
                _goToNextScreen(context);
              })
        ],
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset(
              'images/rain.png',
              width: 490.0,
              height: 1200.0,
              fit: BoxFit.fill,
            ),
          ),
          new Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.fromLTRB(0.0, 10.9, 20.9, 0.0),
            child: new Text(
              '${_cityEntered == null ? util.defaultCity : _cityEntered}',
              style: cityStyle(),
            ),
          ),

          new Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 100.0),
            child: new Image.asset('images/light_rain.png',
              scale: 0.5,
            ),
          ),
          updateTempWidget(_cityEntered)
        ],
      ),
    );
  }

  Future<Map> getWeather(String appId, String city) async {
    String apiUrl =
        'http://api.openweathermap.org/data/2.5/weather?q=$city&appid='
        '${util.appId}&units=metric';

    http.Response response = await http.get(apiUrl);

    return jsonDecode(response.body);
  }

  Widget updateTempWidget(String city) {
    return new FutureBuilder(
        future: getWeather(util.appId, city == null ? util.defaultCity : city),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {

          //Onde obtemos todos os dados do json, configuramos widgets etc.
          if (snapshot.hasData) {
            Map content = snapshot.data;
            return new Container(
              margin: const EdgeInsets.fromLTRB(26.0, 350.0, 0.0, 0.0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new ListTile(
                    title: new Text(
                      content['main']['temp'].toString() +" Cº",
                      style: new TextStyle(
                          fontStyle: FontStyle.normal,
                          fontSize: 51,
                          color: Colors.blue,
                          fontWeight: FontWeight.w800),
                    ),
                    subtitle: new ListTile(
                      title: new Text(
                        "Humidade: ${content['main']['humidity'].toString()}\n"
                            "Mín: ${content['main']['temp_min'].toString()} C º\n"
                            "Máx: ${content['main']['temp_max'].toString()} C º",
                        style: extraData(),

                      ),
                    ),
                  )
                ],
              ),
            );
          } else {
            return new Container();
          }
        });
  }
}

class ChangeCity extends StatelessWidget {

  var _cityFieldController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.teal,
        title: new Text('Mudar Cidade',
        style: new TextStyle(fontSize: 30),


        ),
        centerTitle: true,
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset(
              'images/sunny.png',
              width: 490.0,
              height: 1200.0,
              fit: BoxFit.fill,
            ),
          ),

          new ListView(
            children: <Widget>[
              new ListTile(
                title: new TextField(
                  decoration: new InputDecoration(
                    hintText: 'Digite a Cidade',
                  ),
                  controller: _cityFieldController,
                  keyboardType: TextInputType.text,
                ),

              ),
              new ListTile(
                title: new FlatButton(
                    onPressed: () {
                      Navigator.pop(context, {
                        'enter': _cityFieldController.text
                      });
                    },
                    textColor: Colors.white70,
                    color: Colors.teal,
                    child: new Text(
                      'Pesquisar',
                      style: new TextStyle(fontSize:20, fontWeight: FontWeight.w900),

                      )),
              )
            ],
          )
        ],
      ),
    );
  }
}

TextStyle cityStyle() {
  return new TextStyle(
      color: Colors.white, fontSize: 35, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold);
}

TextStyle extraData() {
  return new TextStyle(
      color: Colors.grey[900],
      fontStyle: FontStyle.normal,
      fontSize: 25.0,
      fontWeight: FontWeight.w900);
}

TextStyle tempStyle() {
  return new TextStyle(
      color: Colors.green,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w900,
      fontSize: 49.9);
}
