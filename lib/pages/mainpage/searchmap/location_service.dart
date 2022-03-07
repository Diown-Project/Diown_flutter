import 'dart:convert';

import 'package:http/http.dart' as http;

class LocationService {
  final String key = 'AIzaSyDmj-qVlSTLcr1v7JYH9YaUzDt-4GIDEW0';

  Future<Map<String, dynamic>> getPlace(String input) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$key';
    var response = await http.get(Uri.parse(url),
        headers: {"HttpHeaders.contentTypeHeader": "application/json"});
    // print(response);
    var json = jsonDecode(response.body);
    print(json);
    if (json['candidates'].isEmpty) {
      print('json');
      return {};
    } else {
      var placeId = json['candidates'][0]['place_id'] as String;
      final String url2 =
          'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key';
      var response2 = await http.get(Uri.parse(url2),
          headers: {"HttpHeaders.contentTypeHeader": "application/json"});
      // print(response2);
      var json2 = jsonDecode(response2.body);
      print(json2);
      var results = json2['result'] as Map<String, dynamic>;
      // print(results);
      return results;
    }
  }
}
