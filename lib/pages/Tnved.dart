import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tnved/modal/TnvedCode.dart';
import 'package:tnved/pages/ApiUrl.dart';
import 'package:http/http.dart' as http;

class TNVED extends StatefulWidget {
  const TNVED({Key? key}) : super(key: key);

  @override
  State<TNVED> createState() => _TNVEDState();
}

class _TNVEDState extends State<TNVED> {
  final List<TnvedCode> _list = [];
  final List<TnvedCode> _serach = [];

  var _postJson = [];
  var loading = false;

  void fetchData() async {
    setState(() {
      loading = true;
    });
    _list.clear();
    final url = Uri.parse(apiUrl);
    try {
      final response = await http.get(url, headers: {
        "Accept": "application/json",
        "Access-Control_Allow_Origin": "*",
      });
      // print(response.body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("200"+response.body);
        setState(() {
          for (var i in data) {
            _list.add(TnvedCode.formJson(i));
            loading = false;
          }
        });
      }
    } catch (err) {
      print(Icons.add);
    }
  }

  TextEditingController controller = new TextEditingController();

  onSearch(String text) async {
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

  @override
  void initState() {
    super.initState();
    fetchData();
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
                  leading: const Icon(Icons.search),
                  title: TextField(
                    controller: controller,
                    onChanged: onSearch,
                    decoration: const InputDecoration(
                        hintText: "Qidiruv", border: InputBorder.none),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      controller.clear();
                      onSearch("");
                    },
                    icon: const Icon(Icons.cancel),
                  ),
                ),
              ),
            ),
            loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Expanded(
                    child: _serach.length != 0 || controller.text.isNotEmpty
                        ? ListView.builder(
                            itemCount: _serach.length,
                            itemBuilder: (context, i) {
                              final t = _serach[i];
                              return Container();
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(bottom: _w / 80),
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
                                              padding: const EdgeInsets.only(
                                                  top: 14),
                                              child: Text(
                                                t.id,
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.blueAccent),
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
                                              padding: const EdgeInsets.only(
                                                  right: 15),
                                              child: Text(
                                                t.u1,
                                                style: const TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 12),
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(
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
