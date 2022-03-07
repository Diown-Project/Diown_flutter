import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:diown/pages/mainpage/direction/direction_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DirectionsRepository {
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/direction/json?';
  final Dio _dio;

  DirectionsRepository({Dio? dio}) : _dio = dio ?? Dio();

  Future<void> getDirections({
    required LatLng origin,
    required LatLng destination,
  }) async {
    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=AIzaSyDmj-qVlSTLcr1v7JYH9YaUzDt-4GIDEW0'));
    var json = jsonDecode(response.body);
    if (response.statusCode == 200) {
      print(json);
      print(json["routes"][0]["legs"][0]['distance']);
    }
  }
}
