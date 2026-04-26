import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

import '../../services/crypto_service.dart';
import '../../services/file_service.dart';
import '../widgets/file_picker_row.dart';
import 'panel_helpers.dart';

class EncryptPanel extends StatefulWidget {
  const EncryptPanel({super.key});

  @override
  State<StatefulWidget> createState() => _EncryptPanelState();
}

class _EncryptPanelState extends State<EncryptPanel> {
  final FileService fileService = FileService();
  final CryptoService cryptoService = CryptoService();

  String? publicKeyPath;
  String? fileToEncryptPath;
  String? outputFilePath;

  final TextEditingController publicKeyController = TextEditingController();
  final TextEditingController fileController = TextEditingController();
  final TextEditingController outputFileController = TextEditingController();

  @override
  void dispose() {
    publicKeyController.dispose();
    fileController.dispose();
    outputFileController.dispose();
    super.dispose();
  }

  Future<void> selectPublicKey() async {
    final String? selectedPath = await fileService.pickFileFromDirectory(sshDirectory);
    if (selectedPath == null) return;

    setState(() {
      publicKeyPath = selectedPath;
      publicKeyController.text = p.basename(selectedPath);
    });
  }

  Future<void> selectFileToEncrypt() async {
    final String? selectedPath = await fileService.pickFileFromDirectory(parentOfCurrentDirectory);
    if (selectedPath == null) return;

    setState(() {
      fileToEncryptPath = selectedPath;
      fileController.text = p.basename(selectedPath);
    });
  }

  Future<void> selectOutputPath() async {
    final String? selectedPath = await fileService.pickFileFromDirectory(parentOfCurrentDirectory);
    if (selectedPath == null) return;

    setState(() {
      outputFilePath = selectedPath;
      outputFileController.text = p.basename(selectedPath);
    });
  }

  Future<void> handleEncrypt() async {
    if (publicKeyPath == null || fileToEncryptPath == null || outputFilePath == null) {
      showError(context, 'Selecciona todos los campos');
      return;
    }

    try {
      await cryptoService.encryptFile(
        inputFilePath: fileToEncryptPath!,
        publicKeyPath: publicKeyPath!,
        outputFilePath: outputFilePath!,
      );

      if (!mounted) return;
      showMessage(context, 'Archivo encriptado con éxito en: ${p.basename(outputFilePath!)}');
    } catch (error) {
      debugPrint('$error');

      if (!mounted) return;
      showError(context, 'Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.lock_outline, color: Colors.deepPurpleAccent),
                SizedBox(width: 8),
                Text(
                  'Encriptar',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 24),
            FilePickerRow(
              label: 'Clave pública (RSA):',
              controller: publicKeyController,
              onSelect: selectPublicKey,
              icon: Icons.vpn_key_outlined,
            ),
            const SizedBox(height: 16),
            FilePickerRow(
              label: 'Archivo a encriptar:',
              controller: fileController,
              onSelect: selectFileToEncrypt,
              icon: Icons.description_outlined,
            ),
            const SizedBox(height: 16),
            FilePickerRow(
              label: 'Archivo encriptado (Destino):',
              controller: outputFileController,
              onSelect: selectOutputPath,
              icon: Icons.save_alt_outlined,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
                onPressed: handleEncrypt,
                icon: const Icon(Icons.lock),
                label: const Text('Encriptar archivo'),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
