import "dart:convert";
import "dart:io";

import "package:mime/mime.dart";

abstract class ImageUtils {
  static Future<String> getImageUrlFromFile(File image) async {
    final imageBytes = await image.readAsBytes();
    final base64Image = base64Encode(imageBytes);
    final mimeType = lookupMimeType(image.path) ?? "image/jpeg";
    return "data:$mimeType;base64,$base64Image";
  }
}
