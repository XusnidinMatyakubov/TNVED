import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tnved/modal/TnvedCode.dart';
import 'package:tnved/pages/ApiUrl.dart';
import 'package:http/http.dart' as http;
import 'package:tnved/pages/simplified_uri.dart';

class TNVED extends StatefulWidget {
  const TNVED({Key? key}) : super(key: key);

  @override
  State<TNVED> createState() => _TNVEDState();
}

class _TNVEDState extends State<TNVED> {
  final List<TnvedCode> _list = [];
  List<TnvedCode> _serach = [];
  static TnvedCode tnvedCode = [] as TnvedCode;

  var loading = false;


  GlobalKey<FormState> key = new GlobalKey<FormState>();
  TextEditingController _controller = TextEditingController();

  _onSearch(String text) async {
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

  getTnved() {
    return tnvedCode;
  }

  Future<TnvedCode?> onSearch(String text) async {
    setState(() {
      loading = true;
    });
    _list.clear();
    try {
      final queryParameters = {"code": _controller.text};

      final Uri uri = SimplifiedUri.uri('${apiUrl}', queryParameters);
      final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
      final response = await http.get(uri, headers: headers);

      print("Response status: ${response.statusCode}");
      // print("Response body: ${response.body}");

      var data = json.decode(response.body);

      if (response.statusCode == 200) {
          setState(() {
            for (var i in data) {
              _list.add(TnvedCode.fromJson(i));
            }
            loading = false;
          });
      } else {
        print("Xatolik");
      }
    } catch (err) {
      print(err);
    }
  }


  @override
  void initState() {
    super.initState();
  }

  final colorBg = Colors.grey[300];

  @override
  Widget build(BuildContext context) {
    double _w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          title: const Center(
        child: Text("TNVED KOD"),
      )),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(5.0),
              color: Colors.white,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                color: Colors.orange.shade200,
                child: ListTile(
                  leading: IconButton(
                    onPressed: () {
                      _controller.clear();
                      _list.clear();
                      onSearch("");
                    },
                    icon: const Icon(Icons.cancel),
                  ),
                  title: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                        hintText: "Qidiruv", border: InputBorder.none),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      setState(() {
                        loading = true;
                      });
                      onSearch(_controller.text);
                    },
                    color: Colors.black,
                    icon: const Icon(Icons.search),
                  ),
                ),
              ),
            ),
            loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Expanded(
                    child: _serach.length != 0 || _controller.text.isNotEmpty
                        ? ListView.builder(
                            itemCount: _list.length,
                            itemBuilder: (context, i) {
                              final t = _list[i];
                              return Container(
                                child: Text(t.id.toString()),
                              );
                            })
                        : ListView.builder(
                            itemCount: _list.length,
                            itemBuilder: (context, i) {
                              final t = _list[i];
                              return InkWell(
                                onTap: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => Conversiya(
                                  //         a.code, a.rate, a.ccy, a.ccyNmUz),
                                  //   ),
                                  // );
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      top: 3, bottom: 3, left: 10, right: 10),
                                  // color: Colors.white,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin:
                                            EdgeInsets.only(bottom: _w / 80),
                                        height: 75,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20)),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.3),
                                              blurRadius: 40,
                                              spreadRadius: 10,
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Wrap(
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 14),
                                                  child: Text(
                                                    t.id,
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        color:
                                                            Colors.blueAccent),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 15),
                                                  child: Text(
                                                    t.u1,
                                                    style: const TextStyle(
                                                        color: Colors.black54,
                                                        fontSize: 12),
                                                  ),
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 15),
                                                  child: Text(
                                                    t.unit2,
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Text(a.ccy),
                                    ],
                                  ),
                                ),
                              );
                            }),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeft() {
    return const Center(
      child: Text("SASA"),
    );
  }

  Widget _buildRight() {
    return const Center(
      child: Icon(Icons.airplanemode_active),
    );
  }
}
