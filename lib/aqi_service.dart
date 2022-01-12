import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
class Station {
  String Country ='';
  String siteName ='';
  int aqi = -1;
  String Status ='';
  String So2 ='';
  String Co ='';
  String No = '';
  String No2 = '';
  String PublishTime='';
  int PM_10 =-1;
  int PM_2_5 =-1;

  Station({required this.siteName});

  Station.fromJson(Map<String, dynamic> json) {
    Country = json['County'];
    siteName = json['SiteName'];
    aqi = int.tryParse(json['AQI']) ?? -1;
    PublishTime = json['PublishTime'];
    Status = json['Status'];
    So2 = json['SO2'];
    Co = json['CO'];
    No = json['NO'];
    No2 = json['NO2'];
    PM_10 = int.tryParse(json['PM10']) ?? -1;
    PM_2_5 = int.tryParse(json['PM2.5']) ?? -1;
  }
}

Future<List<Station>> fetchAQI() async{ 
  List<Station> stations = [];
  //  final search  = await http.get(Uri.parse(
  //     'https://data.epa.gov.tw/api/v1/aqx_p_432?format=json&offset=0&limit=100&api_key=fca3f5d6-eea6-4c1b-8b3a-2e2bf0a1bd85&filters=SiteName,EQ,'+value  
  //   ));
  final response = await http.get(Uri.parse(
      'https://data.epa.gov.tw/api/v1/aqx_p_432?format=json&offset=0&limit=100&api_key=fca3f5d6-eea6-4c1b-8b3a-2e2bf0a1bd85'  
    ));
  // http.get(Uri.parse('http:...'))
  // .then((response){
  //    debugPrint('response gotten');
  // if (response.statusCode == 200) {
  //   debugPrint('result gotten');
  // } else {
  //   debugPrint('status code:${response.statusCode}');
  //   throw Exception('Failed to load data');
  // }
  // });
  debugPrint('response gotten');

  if (response.statusCode == 200) {
    var res = jsonDecode(response.body);
    List<dynamic> stationsInJson = res['records'];
    for (var station in stationsInJson){
      debugPrint(station['SiteName']);
      stations.add(Station.fromJson(station));
    }
    debugPrint('${stations.length} stations gotten');
  } else {
    debugPrint('status code:${response.statusCode}');
    throw Exception('Failed to load data');
  }
  return stations;
}

Future<List<Station>> searchAQI(String value) async{ 
  List<Station> stations = [];
   final search  = await http.get(Uri.parse(
      'https://data.epa.gov.tw/api/v1/aqx_p_432?format=json&offset=0&limit=100&api_key=fca3f5d6-eea6-4c1b-8b3a-2e2bf0a1bd85&filters=SiteName,EQ,'+value  
    ));
  // http.get(Uri.parse('http:...'))
  // .then((response){
  //    debugPrint('response gotten');
  // if (response.statusCode == 200) {
  //   debugPrint('result gotten');
  // } else {
  //   debugPrint('status code:${response.statusCode}');
  //   throw Exception('Failed to load data');
  // }
  // });
  debugPrint('response gotten');

  if (search.statusCode == 200) {
    var res = jsonDecode(search.body);
    List<dynamic> stationsInJson = res['records'];
    for (var station in stationsInJson){
      debugPrint(station['SiteName']);
      stations.add(Station.fromJson(station));
    }
    debugPrint('${stations.length} stations gotten');
  } else {
    debugPrint('status code:${search.statusCode}');
    throw Exception('Failed to load data');
  }
  return stations;
}