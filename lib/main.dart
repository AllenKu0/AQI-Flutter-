import 'package:flutter/material.dart';
import 'package:ui_1229/Message.dart';
import 'package:ui_1229/aqi_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("空氣品質(AQI)"),
        ),
        body: AQUList(),
      ),
    );
  }
}

class AQUList extends StatefulWidget {
  const AQUList({Key? key}) : super(key: key);

  @override
  _AQUListState createState() => _AQUListState();
}

class _AQUListState extends State<AQUList> {
  Future<List<Station>>? futureStationList;
  late Color aqiTextBackgroundColor;
  String healthMessage = '';
  String suggestMessage = '';
  String _inputValue = '';
  @override
  void initState() {
    super.initState();
    futureStationList = fetchAQI();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Column(children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Please Input Here',
                hintText: '(ex: 美濃)',
              ),
              onChanged: (value) {
                debugPrint(value);
                _inputValue = value;
              },
            ),
            ElevatedButton(
              onPressed: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchResult(
                        search: _inputValue,
                      ),
                    ))
              },
              child: const Text('搜尋'),
            ),
          ]),
          Container(
            height: 500,
            child: FutureBuilder<List<Station>>(
              future: futureStationList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  print(snapshot.data);
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      if (snapshot.data![index].aqi >= 0 &&
                          snapshot.data![index].aqi <= 50) {
                        aqiTextBackgroundColor = Colors.green;
                        healthMessage = Message.greenhealthMessage.toString();
                        suggestMessage = Message.greensuggestMessage.toString();
                      } else if (snapshot.data![index].aqi >= 51 &&
                          snapshot.data![index].aqi <= 100) {
                        aqiTextBackgroundColor = Colors.yellow;
                        healthMessage = Message.yellowhealthMessage.toString();
                        suggestMessage =
                            Message.yellowsuggestMessage.toString();
                      } else if (snapshot.data![index].aqi >= 101 &&
                          snapshot.data![index].aqi <= 150) {
                        aqiTextBackgroundColor = Colors.orange;
                        healthMessage = Message.orangehealthMessage.toString();
                        suggestMessage =
                            Message.orangesuggestMessage.toString();
                      } else if (snapshot.data![index].aqi >= 151 &&
                          snapshot.data![index].aqi <= 200) {
                        aqiTextBackgroundColor = Colors.red;
                        healthMessage = Message.redhealthMessage.toString();
                        suggestMessage = Message.redsuggestMessage.toString();
                      } else if (snapshot.data![index].aqi >= 201 &&
                          snapshot.data![index].aqi <= 300) {
                        aqiTextBackgroundColor = Colors.purple;
                        healthMessage = Message.purplehealthMessage.toString();
                        suggestMessage =
                            Message.purplesuggestMessage.toString();
                      } else if (snapshot.data![index].aqi > 300) {
                        aqiTextBackgroundColor = Colors.redAccent.shade700;
                        healthMessage =
                            Message.redAccenthealthMessage.toString();
                        suggestMessage =
                            Message.redAccentsuggestMessage.toString();
                      }
                      print('build ${index}');
                      return ListTile(
                        title: Text(
                          snapshot.data![index].siteName,
                          textAlign: TextAlign.center,
                        ),
                        subtitle: Container(
                          constraints:
                              const BoxConstraints(maxWidth: 10, maxHeight: 20),
                          padding: const EdgeInsets.only(
                              left: 10, top: 0, right: 10, bottom: 0),
                          decoration: BoxDecoration(
                            color: aqiTextBackgroundColor,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20)),
                          ),
                          child: Text(
                            snapshot.data![index].aqi.toString(),
                            style: TextStyle(
                              color: Colors.black,
                              backgroundColor: aqiTextBackgroundColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        onTap: () {
                          debugPrint(snapshot.data![index].siteName.toString());
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailPage(
                                  Country: snapshot.data![index].Country,
                                  aqi: snapshot.data![index].aqi,
                                  SiteName: snapshot.data![index].siteName,
                                  Status: snapshot.data![index].Status,
                                  PublishTime:
                                      snapshot.data![index].PublishTime,
                                  So2: snapshot.data![index].So2,
                                  Co: snapshot.data![index].Co,
                                  No: snapshot.data![index].No,
                                  No2: snapshot.data![index].No2,
                                  PM_10: snapshot.data![index].PM_10,
                                  PM_2_5: snapshot.data![index].PM_2_5,
                                ),
                              ));
                        },
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final String Country;
  final int aqi;
  final String SiteName;
  final String Status;
  final String PublishTime;
  final String So2;
  final String Co;
  final String No;
  final String No2;
  final int PM_10;
  final int PM_2_5;
  String healthMessage = '';
  String suggestMessage = '';
  DetailPage(
      {required this.Country,
      required this.aqi,
      required this.SiteName,
      required this.Status,
      required this.PublishTime,
      required this.So2,
      required this.Co,
      required this.No,
      required this.No2,
      required this.PM_10,
      required this.PM_2_5,
      Key? key})
      : super(key: key);
  // required this.So,required this.Co,

  @override
  Widget build(BuildContext context) {
    if (aqi >= 0 && aqi <= 50) {
      healthMessage = Message.greenhealthMessage.toString();
      suggestMessage = Message.greensuggestMessage.toString();
    } else if (aqi >= 51 && aqi <= 100) {
      healthMessage = Message.yellowhealthMessage.toString();
      suggestMessage = Message.yellowsuggestMessage.toString();
    } else if (aqi >= 101 && aqi <= 150) {
      healthMessage = Message.orangehealthMessage.toString();
      suggestMessage = Message.orangesuggestMessage.toString();
    } else if (aqi >= 151 && aqi <= 200) {
      healthMessage = Message.redhealthMessage.toString();
      suggestMessage = Message.redsuggestMessage.toString();
    } else if (aqi >= 201 && aqi <= 300) {
      healthMessage = Message.purplehealthMessage.toString();
      suggestMessage = Message.purplesuggestMessage.toString();
    } else if (aqi > 300) {
      healthMessage = Message.redAccenthealthMessage.toString();
      suggestMessage = Message.redAccentsuggestMessage.toString();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(SiteName),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Text(
                "城市: ",
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(
              left: 30,
            ),
            child: Text(
              Country,
              style: TextStyle(fontSize: 20, color: Colors.blue.shade700),
            ),
            alignment: Alignment.centerLeft,
          ),
          Row(
            children: [
              Text(
                "狀態: ",
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(
              left: 30,
            ),
            child: Text(
              Status,
              style: TextStyle(fontSize: 20, color: Colors.blue.shade700),
            ),
            alignment: Alignment.centerLeft,
          ),
          Row(
            children: [
              Text(
                "化學物質: ",
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "So2: ",
                      style: TextStyle(fontSize: 20),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 30,
                      ),
                      child: Text(So2 + "（μg/m3）",
                          style: TextStyle(
                              fontSize: 20, color: Colors.blue.shade700)),
                      alignment: Alignment.centerLeft,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "Co: ",
                      style: TextStyle(fontSize: 20),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 30,
                      ),
                      child: Text(
                        Co + "（μg/m3）",
                        style: TextStyle(
                            fontSize: 20, color: Colors.blue.shade700),
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "No: ",
                      style: TextStyle(fontSize: 20),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 30,
                      ),
                      child: Text(
                        No + "（μg/m3）",
                        style: TextStyle(
                            fontSize: 20, color: Colors.blue.shade700),
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "No2: ",
                      style: TextStyle(fontSize: 20),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 30,
                      ),
                      child: Text(
                        No2 + "（μg/m3）",
                        style: TextStyle(
                            fontSize: 20, color: Colors.blue.shade700),
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "PM10: ",
                      style: TextStyle(fontSize: 20),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 30,
                      ),
                      child: Text(
                        PM_10.toString() + "（μg/m3）",
                        style: TextStyle(
                            fontSize: 20, color: Colors.blue.shade700),
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "PM2.5: ",
                      style: TextStyle(fontSize: 20),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 30,
                      ),
                      child: Text(
                        PM_2_5.toString() + "（μg/m3）",
                        style: TextStyle(
                            fontSize: 20, color: Colors.blue.shade700),
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(children: [
            Text("對健康的影響:", style: TextStyle(fontSize: 20)),
          ]),
          Container(
            padding: EdgeInsets.only(
              left: 30,
            ),
            child: Text(
              healthMessage,
              style: TextStyle(fontSize: 18, color: Colors.blue.shade700),
            ),
            alignment: Alignment.centerLeft,
          ),
          Row(children: [
            Text("建議採取的措施:", style: TextStyle(fontSize: 20)),
          ]),
          Container(
            padding: EdgeInsets.only(
              left: 30,
            ),
            child: Text(
              suggestMessage,
              style: TextStyle(fontSize: 18, color: Colors.blue.shade700),
            ),
            alignment: Alignment.centerLeft,
          ),
          Row(
            children: [
              Text(
                "更新時間:",
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(
              left: 30,
            ),
            child: Text(
              PublishTime,
              style: TextStyle(fontSize: 20, color: Colors.blue.shade700),
            ),
            alignment: Alignment.centerLeft,
          ),
        ],
      ),
    );
  }
}

class SearchResult extends StatelessWidget {
  final search;
  const SearchResult({required this.search, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
          appBar: AppBar(
            title: Text("搜尋結果"),
          ),
          body: Column(children: [
            SearchPage(search: search),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('返回上頁'),
            ),
          ])),
    );
  }
}

class SearchPage extends StatefulWidget {
  final search;
  const SearchPage({required this.search, Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState(search: this.search);
}

class _SearchPageState extends State<SearchPage> {
  Future<List<Station>>? futureStationList;
  late Color aqiTextBackgroundColor;
  String healthMessage = '';
  String suggestMessage = '';
  final search;
  _SearchPageState({required this.search});
  @override
  void initState() {
    super.initState();
    futureStationList = searchAQI(search);
  }

  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        height: 100,
        child: FutureBuilder<List<Station>>(
            future: futureStationList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                debugPrint('${snapshot.data}');
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    debugPrint("build: $index");
                    if (snapshot.data![index].aqi >= 0 &&
                        snapshot.data![index].aqi <= 50) {
                      aqiTextBackgroundColor = Colors.green;
                    } else if (snapshot.data![index].aqi >= 51 &&
                        snapshot.data![index].aqi <= 100) {
                      aqiTextBackgroundColor = Colors.yellow;
                    } else if (snapshot.data![index].aqi >= 101 &&
                        snapshot.data![index].aqi <= 150) {
                      aqiTextBackgroundColor = Colors.orange;
                    } else if (snapshot.data![index].aqi >= 151 &&
                        snapshot.data![index].aqi <= 200) {
                      aqiTextBackgroundColor = Colors.red;
                    } else if (snapshot.data![index].aqi >= 201 &&
                        snapshot.data![index].aqi <= 300) {
                      aqiTextBackgroundColor = Colors.purple;
                    } else if (snapshot.data![index].aqi > 300) {
                      aqiTextBackgroundColor = Colors.redAccent.shade700;
                    }

                    return ListTile(
                      title: Text(
                        snapshot.data![index].siteName,
                        textAlign: TextAlign.center,
                      ),
                      subtitle: Container(
                        constraints:
                            const BoxConstraints(maxWidth: 10, maxHeight: 20),
                        padding: const EdgeInsets.only(
                            left: 10, top: 0, right: 10, bottom: 0),
                        decoration: BoxDecoration(
                          color: aqiTextBackgroundColor,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20)),
                        ),
                        child: Text(
                          snapshot.data![index].aqi.toString(),
                          style: TextStyle(
                            color: Colors.black,
                            backgroundColor: aqiTextBackgroundColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailPage(
                                      Country: snapshot.data![index].Country,
                                      aqi: snapshot.data![index].aqi,
                                      SiteName: snapshot.data![index].siteName,
                                      Status: snapshot.data![index].Status,
                                      PublishTime:
                                          snapshot.data![index].PublishTime,
                                      So2: snapshot.data![index].So2,
                                      Co: snapshot.data![index].Co,
                                      PM_10: snapshot.data![index].PM_10,
                                      PM_2_5: snapshot.data![index].PM_2_5,
                                      No: snapshot.data![index].No,
                                      No2: snapshot.data![index].No2,
                                    )));
                      },
                      trailing: const Icon(Icons.navigate_next),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    ]);
  }
}
