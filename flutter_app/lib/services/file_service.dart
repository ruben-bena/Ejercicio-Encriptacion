import 'package:file_picker/file_picker.dart';
import 'dart:io';

class FileService {

  Future<String?> pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return null;
    return result.files.single.path;
  }

  // Utilizando ruta inicial
  Future<String?> pickFileFromDirectory(String initialDirectory) async {
    // String home = Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'] ?? '';
    final result = await FilePicker.platform.pickFiles(initialDirectory: initialDirectory);
    if (result == null) return null;
    return result.files.single.path;
  }
}