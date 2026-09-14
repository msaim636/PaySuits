import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ViewFile {
  // Method to download a file
  static Future<File?> viewFile({required String url}) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/invoice.pdf');

    try {
      // Download the file
      final response = await http.get(Uri.parse(url));

      // Print response code
      print("Response code: ${response.statusCode}");
      if (response.statusCode == 200) {
        // Write file content
        await file.writeAsBytes(response.bodyBytes);
        return file;
      } else {
        print("Failed: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }
}
