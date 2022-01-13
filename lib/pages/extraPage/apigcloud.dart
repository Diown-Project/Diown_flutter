import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:mime/mime.dart';
import 'package:gcloud/storage.dart';

class CloudApi {
  final auth.ServiceAccountCredentials? _credentials;
  auth.AutoRefreshingAuthClient? _client;
  CloudApi(String json)
      : _credentials = auth.ServiceAccountCredentials.fromJson(json);

  save(List<String> name, List<Uint8List> imgBytes) async {
    // create client
    print(imgBytes.length);
    for (var i = 0; i < imgBytes.length; i++) {
      if (_client == null) {
        _client =
            await auth.clientViaServiceAccount(_credentials!, Storage.SCOPES);

        //TODO Instantiate objects to cloud storage
        var storage = Storage(_client!, 'diown');
        var bucket = storage.bucket('noseason');
        final type = lookupMimeType(name[i]);
        await bucket.writeBytes(name[i], imgBytes[i],
            metadata: ObjectMetadata(
              contentType: type,
            ));
      } else {
        var storage = Storage(_client!, 'diown');
        var bucket = storage.bucket('noseason');
        final type = lookupMimeType(name[i]);
        await bucket.writeBytes(name[i], imgBytes[i],
            metadata: ObjectMetadata(
              contentType: type,
            ));
      }
    }
    return true;
  }
}
