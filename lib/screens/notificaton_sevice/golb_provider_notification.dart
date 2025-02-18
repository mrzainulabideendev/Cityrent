import 'dart:convert';
import 'package:car_rent/screens/notificaton_sevice/getServiseKey.dart';
import 'package:http/http.dart' as http;

import 'package:car_rent/utilz/contants/export.dart';

class GolbProviderNotification extends ChangeNotifier {
  String fcmApiUrl =
      'https://fcm.googleapis.com/v1/projects/car-rent-91119/messages:send';
  Future<void> sendFCMNotification({
    required String title,
    required String body,
    required String collection,
    required String uid,
  }) async {
    String? accessToken = await GetServerKey().getServerKeyToken();

    var user = FirebaseFirestore.instance.collection(collection);
    var userdata = await user.doc(uid).get();

    // Check if the user document exists
    if (!userdata.exists) {
      print('User document does not exist.');
      return;
    }

    Map<String, dynamic> userData = userdata.data()!;
    String? deviceToken =
        userData["getDeviceToken"]; 
    if (deviceToken != null) {
      try {
        final data = {
          "message": {
            "token": deviceToken,
            "notification": {
              "title": title,
              "body": body,
            }
          }
        };

        final response = await http.post(
          Uri.parse(fcmApiUrl),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $accessToken',
          },
        );

        if (response.statusCode == 200) {
          print('Notification sent successfully');
        } else {
          print(
              'Failed to send notification. Status code: ${response.statusCode}, Response: ${response.body}');
        }
      } catch (e) {
        print('Error: $e');
      }
    } else {
      print('Device token is null for user: $uid');
      await FirebaseFirestore.instance
          .collection(collection)
          .doc(uid)
          .collection("waitingNoti")
          .add({
        'title': title,
        'body': body,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }
}
////////////////////////////////////////
