import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:googleapis_auth/auth_io.dart';

class GetServerKey {
  Future<String> getServerKeyToken() async {
    final jsonString = await rootBundle.loadString('assets/serviceAccountKey.json');
    final jsonMap = json.decode(jsonString);

    final scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    final credentials = ServiceAccountCredentials.fromJson(jsonMap);

    final client = await clientViaServiceAccount(credentials, scopes);

    final accessServerKey = client.credentials.accessToken.data;
    return accessServerKey;
  }
}
