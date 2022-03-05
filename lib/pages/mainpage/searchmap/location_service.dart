import 'dart:convert';

import 'package:http/http.dart' as http;

class LocationService {
  final String key = 'AIzaSyDmj-qVlSTLcr1v7JYH9YaUzDt-4GIDEW0';

  Future<String> getPlaceId(String input) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$key';
    var response = await http.get(Uri.parse(url));
    var json = jsonDecode(response.body);
    print(json);
    var placeId = json['candidates'][0]['place_id'] as String;
    print(placeId);
    return placeId;
  }
}
