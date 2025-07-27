import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'dart:convert';

class ImageUploadService {
  static const String _apiKey = 'd4a73cb98e93f9802c42fe2f85429195'; // Замените на ваш ключ ImgBB

  Future<String> uploadImage({
    required String filePath,
    required String userId,
  }) async {
    try {
      final file = File(filePath);
      final bytes = await file.readAsBytes();
      final fileName = '${const Uuid().v4()}.jpg';

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.imgbb.com/1/upload'),
      );

      request.fields['key'] = _apiKey;
      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          bytes,
          filename: fileName,
        ),
      );

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final jsonResponse = jsonDecode(responseBody);

      if (response.statusCode == 200 && jsonResponse['success']) {
        return jsonResponse['data']['url'];
      } else {
        throw Exception('Image upload failed: ${jsonResponse['error']['message']}');
      }
    } catch (e) {
      throw Exception('Image upload failed: $e');
    }
  }
}