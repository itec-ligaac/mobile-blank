/*
 * Copyright (C) 2019-2021 HERE Europe B.V.
 *
 * Licensed under the Apache License, Version 2.0 (the "License")
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * SPDX-License-Identifier: Apache-2.0
 * License-Filename: LICENSE
 */

import 'package:flutter/material.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/mapview.dart';

import '../RoutingExample.dart';
import 'AvatarPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Homepage extends StatelessWidget {
  // Use _context only within the scope of this widget.
  BuildContext _context;
  RoutingExample _routingExample;

  final List<String> list = List.generate(10, (index) => "Text $index");

  @override
  Widget build(BuildContext context) {
    _context = context;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("blank"),
          backgroundColor: Color.fromRGBO(136, 100, 172, 100),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () async {
                var result = await showSearch(
                  context: context,
                  delegate: Search(list),
                );
                _createroute(result);
              },
            )
          ],
        ),
        body: Stack(
          children: [
            HereMap(onMapCreated: _onMapCreated),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     button('Add Route', _addRouteButtonClicked),
            //     button('Clear Map', _clearMapButtonClicked),
            //   ],
            // ),
            new GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AvatarPage()),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20, right: 20),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://cdn.discordapp.com/avatars/255393543453933568/9061cfc06a3f1dc197f35198a835a169.png?size=1024'),
                      radius: 35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _createroute(var result) async {
    var apiUrl =
        "https://discover.search.hereapi.com/v1/discover?at=46.1753793,21.3196342&limit=2&q=${result}&apiKey=oj8CaBYZKNp8tZk0i3LSMiYqOw0XT1l0-_yu3KBPAlc";
    var response = await http.get(apiUrl);
    var json = jsonDecode(response.body);
    print(json['position']);
    //return json.decode(response.body)['results'];

    _routingExample.addRoute(GeoCoordinates(46.1753793, 21.3196342),GeoCoordinates(46.16282272338867, 21.29153823852539));
  }

  void _onMapCreated(HereMapController hereMapController) {
    hereMapController.mapScene.loadSceneForMapScheme(MapScheme.normalDay,
        (MapError error) {
      if (error == null) {
        double distanceToEarthInMeters = 10000;
        hereMapController.camera.lookAtPointWithDistance(
            GeoCoordinates(46.16282272338867, 21.29153823852539),
            distanceToEarthInMeters);
        _routingExample = RoutingExample(_showDialog, hereMapController);
      } else {
        print("Map scene not loaded. MapError: " + error.toString());
      }
    });
  }

  // void _addRouteButtonClicked() {
  //   _routingExample.addRoute();
  // }

  void _clearMapButtonClicked() {
    _routingExample.clearMap();
  }

  // A helper method to add a button on top of the HERE map.
  Align button(String buttonLabel, Function callbackFunction) {
    return Align(
      alignment: Alignment.topCenter,
      child: RaisedButton(
        color: Color.fromRGBO(136, 100, 172, 100),
        textColor: Colors.white,
        onPressed: () => callbackFunction(),
        child: Text(buttonLabel, style: TextStyle(fontSize: 20)),
      ),
    );
  }

  // A helper method to show a dialog.
  Future<void> _showDialog(String title, String message) async {
    return showDialog<void>(
      context: _context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class Search extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  String selectedResult = "";

  @override
  Widget buildResults(BuildContext context) {
    return new GestureDetector(
        onTap: () {
          Navigator.pop(context, selectedResult);
        },
        child: Container(
          child: Center(
            child: Text(selectedResult),
          ),
        ));
  }

  final List<String> listExample;
  Search(this.listExample);

  List<String> recentList = [
    "Arad",
    "Timisoara",
    "Bucuresti",
    "Cluj-Napoca",
    "Iasi"
  ];

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestionList = [];
    query.isEmpty
        ? suggestionList = recentList //In the true case
        : suggestionList.addAll(listExample.where(
            // In the false case
            (element) => element.contains(query),
          ));

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            suggestionList[index],
          ),
          leading: query.isEmpty ? Icon(Icons.access_time) : SizedBox(),
          onTap: () {
            selectedResult = suggestionList[index];
            showResults(context);
          },
        );
      },
    );
  }
}
