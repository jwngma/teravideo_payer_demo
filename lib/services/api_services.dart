import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:tera_player/models/video_details_model.dart';

class ApiServices {
  static const String _baseUrl =
      'https://us-central1-final-flutter-projects.cloudfunctions.net/expressApi';

  static Future<VideoDetailsModel?> getTeraboxVideoDetails(String url) async {
    try {
      var headers = {
        'Content-Type': 'application/json',
      };

      var request = http.Request(
        'POST',
        Uri.parse("$_baseUrl/terabox/getVideoDetails"),
      );
      request.body = json.encode({"url": url});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final jsonStr = await response.stream.bytesToString();
        final jsonData = json.decode(jsonStr);
        return VideoDetailsModel.fromJson(jsonData);
      } else {
        debugPrint('Error: ${response.reasonPhrase}');
        return null;
      }
    } catch (e) {
      debugPrint('Exception: $e');
      return null;
    }
  }

  static Future<String?> getDownloadableLink({
    required int shareId,
    required int uk,
    required String sign,
    required int timestamp,
    required int fsId,
  }) async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
        'POST',
        Uri.parse('$_baseUrl/terabox/getDownloadableLink'),
      );
      request.body = json.encode({
        "shareid": shareId,
        "uk": uk,
        "sign": sign,
        "timestamp": timestamp,
        "fsId": fsId,
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final jsonStr = await response.stream.bytesToString();
        final data = json.decode(jsonStr);
        if (data['ok'] == true && data['downloadLink'] != null) {
          return data['downloadLink'];
        } else {
          debugPrint("Download link missing in response");
          return null;
        }
      } else {
        debugPrint('Download link error: ${response.reasonPhrase}');
        return null;
      }
    } catch (e) {
      debugPrint('Download link exception: $e');
      return null;
    }
  }

}
