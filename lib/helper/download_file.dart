import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadFile {
  // Method to download a file

  static Future<File?> downloadFile({required String url}) async {

     // Request storage permission
    if (!(await requestStoragePermission())) {
      print("Storage permission denied");
      return null;
    }

    // Define the custom directory path based on platform

    final Directory appStorage = Platform.isIOS
        ? await getApplicationDocumentsDirectory()
       : Directory('/storage/emulated/0/Download') ;



    if (!await appStorage.exists()) {
      await appStorage.create(recursive: true);}
    // Generate file name
    final rand = DateTime.now().millisecondsSinceEpoch;
    final name = "$rand-${url.split('/').last}";
    final file = File('${appStorage.path}/$name');
    print("File path: ${file.path}");
    try {
      // Download the file
      final response = await http.get(Uri.parse(url));
      // Print response code
      print("Response code: ${response.statusCode}");
      if (response.statusCode == 200) {
        // Write file content
        await file.writeAsBytes(response.bodyBytes);
        print("Downloaded file: $name");
        return file;
      } else {
        print("Failed to download file: ${response.statusCode}");
        return null;}
    } catch (e) {
      print("Error downloading file: $e");
      return null;}
  }

  // Function to request storage permission
  static Future<bool> requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      status = await Permission.storage.request();
    }
    return status.isGranted;
  }
}

