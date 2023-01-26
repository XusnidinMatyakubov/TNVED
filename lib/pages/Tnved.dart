import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tnved/modal/TnvedCode.dart';
import 'package:tnved/pages/ApiUrl.dart';
import 'package:http/http.dart' as http;
import 'package:tnved/pages/simplified_uri.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tnved/routes/AppOpenAdManager.dart';
import 'package:tnved/routes/feature_store_secrets.dart';

class TNVED extends StatefulWidget {
  const TNVED({Key? key}) : super(key: key);

  @override
  State<TNVED> createState() => _TNVEDState();
}

class _TNVEDState extends State<TNVED> with WidgetsBindingObserver{
  final List<TnvedCode> _list = [];
  List<TnvedCode> _serach = [];
  static TnvedCode tnvedCode = [] as TnvedCode;

  AppOpenAdManager appOpenAdManager = AppOpenAdManager();
  bool isPaused = false;
  bool _adLoaded = false;
  late BannerAd _bannerAd;

  var loading = false;

  GlobalKey<FormState> key = new GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();

  String xato = "";

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

      print("Response status code: ${response.statusCode}");
      // print("Response body: ${response.body}");

      var data = json.decode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          for (var i in data) {
            _list.add(TnvedCode.fromJson(i));
          }
          loading = false;
        });
      } else if (response.statusCode == 404) {
        final queryParameters = {"name": _controller.text};
        final Uri uri = SimplifiedUri.uri('${apiUrl}', queryParameters);
        final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
        final response = await http.get(uri, headers: headers);

        print("Response status name: ${response.statusCode}");
        // print("Response body: ${response.body}");

        var data = json.decode(response.body);

        if (response.statusCode == 200) {
          setState(() {
            for (var i in data) {
              _list.add(TnvedCode.fromJson(i));
            }
            loading = false;
          });
        } else if (response.statusCode == 404) {
          setState(() {
            xato = _controller.text;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ErrorModal(xato)),
            );
          });
          // xato="Siz qidiorgan "+_controller.text +" tnved kodi topilmadi";
          loading = false;
        }
      }
    } catch (err) {
      print(err);
    }
    return null;
  }

  @override
  void initState() {
    onSearch("");
    super.initState();
    appOpenAdManager.loadAd();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      isPaused = true;
    }
    if (state == AppLifecycleState.resumed && isPaused) {
      print("Resumed==========================");
      appOpenAdManager.showAdIfAvailable();
      isPaused = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _bannerAd.dispose();
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    _loadAd();
  }

  Future<void> _loadAd() async {
    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: MySecretsHelper.bannerAdUnitId,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) => setState(() {
          _bannerAd =ad as BannerAd;
          _adLoaded = true;
        }),
        onAdFailedToLoad: (ad, error) => ad.dispose(),
      ),
    );
    return _bannerAd.load();
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
      bottomNavigationBar: Container(
        alignment: Alignment.center,
        width: _bannerAd.size.width.toDouble(),
        height: _bannerAd.size.height.toDouble(),
        child: _adLoaded ? AdWidget(ad: _bannerAd) : const LinearProgressIndicator(),
      ),
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
                              final l = _list[i];
                              return SingleChildScrollView(
                                child: Container(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Card(
                                    color: Colors.white54,
                                    clipBehavior: Clip.antiAlias,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ListTile(
                                          title: Text(
                                            l.id,
                                            style: const TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          // trailing: Icon(
                                          //   alreadySaved
                                          //       ? Icons.star_outlined
                                          //       : Icons.star_border_outlined,
                                          //   color: alreadySaved ? Colors.red : null,
                                          // ),
                                        ),
                                        const Divider(
                                          color: Colors.black,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                padding:
                                                const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                                                child: Text(
                                                  l.name,
                                                  style: const TextStyle(
                                                    fontSize: 16.0,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                            ),
                                            // Wrap(
                                            //   crossAxisAlignment:
                                            //       WrapCrossAlignment.end,
                                            //   children: [
                                            //     Container(
                                            //       color: Colors.black12,
                                            //       padding:
                                            //           const EdgeInsets.all(5.0),
                                            //       child: Text(
                                            //         l.u1,
                                            //         style: const TextStyle(
                                            //             color: Colors.black),
                                            //       ),
                                            //     ),
                                            //     Container(
                                            //       color: Colors.black12,
                                            //       padding:
                                            //           const EdgeInsets.all(5.0),
                                            //       child: Text(
                                            //         l.startdate.toString(),
                                            //         style: const TextStyle(
                                            //             color: Colors.black),
                                            //       ),
                                            //     ),
                                            //   ],
                                            // ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            })
                        : ListView.builder(
                            itemCount: _list.length,
                            itemBuilder: (context, i) {
                              final t = _list[i];
                              return SingleChildScrollView(
                                child: Container(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Card(
                                    color: Colors.white54,
                                    clipBehavior: Clip.antiAlias,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ListTile(
                                          title: Text(
                                            t.id,
                                            style: const TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          // trailing: Icon(
                                          //   alreadySaved
                                          //       ? Icons.star_outlined
                                          //       : Icons.star_border_outlined,
                                          //   color: alreadySaved ? Colors.red : null,
                                          // ),
                                        ),
                                        const Divider(
                                          color: Colors.black,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                                                child: Text(
                                                  t.name,
                                                  style: const TextStyle(
                                                    fontSize: 16.0,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                            ),
                                            // Wrap(
                                            //   crossAxisAlignment:
                                            //       WrapCrossAlignment.end,
                                            //   children: [
                                            //     Container(
                                            //       color: Colors.black12,
                                            //       padding:
                                            //           const EdgeInsets.all(5.0),
                                            //       child: Text(
                                            //         t.u1,
                                            //         style: const TextStyle(
                                            //             color: Colors.black),
                                            //       ),
                                            //     ),
                                            //     Container(
                                            //       color: Colors.black12,
                                            //       padding:
                                            //           const EdgeInsets.all(5.0),
                                            //       child: Text(
                                            //         t.startdate.toString(),
                                            //         style: const TextStyle(
                                            //             color: Colors.black),
                                            //       ),
                                            //     ),
                                            //   ],
                                            // ),
                                          ],
                                        ),
                                      ],
                                    ),
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

class ErrorModal extends StatelessWidget {
  final String xato;

  const ErrorModal(String this.xato, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: AlertDialog(

          title: Text("Ilovadan qidirildi -> " + "'"+ xato.toString() +"'"),
          titleTextStyle: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
          backgroundColor: Colors.orangeAccent,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          content: const Text("Qidiruv natijasi 0", style: TextStyle(fontSize: 16),),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('Qaytish', style: TextStyle(color: Colors.black),),
            ),
          ],
        ),
      ),
    );
  }
}
