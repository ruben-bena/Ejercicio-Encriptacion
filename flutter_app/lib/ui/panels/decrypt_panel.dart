import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

import '../../services/crypto_service.dart';
import '../../services/file_service.dart';
import '../widgets/file_picker_row.dart';
import 'panel_helpers.dart';

class DecryptPanel extends StatefulWidget {
  const DecryptPanel({super.key});

  @override
  State<DecryptPanel> createState() => _DecryptPanelState();
}

class _DecryptPanelState extends State<DecryptPanel> {
  final FileService fileService = FileService();
  final CryptoService cryptoService = CryptoService();

  String? privateKeyPath = '$sshDirectory/id_rsa';
  String? fileToDecryptPath;
  String? outputFilePath;

  final TextEditingController privateKeyController = TextEditingController();
  final TextEditingController encryptedFileController = TextEditingController();
  final TextEditingController outputFileController = TextEditingController();

  @override
  void initState() {
    super.initState();
    privateKeyController.text = p.basename(privateKeyPath!);
  }

  @override
  void dispose() {
    privateKeyController.dispose();
    encryptedFileController.dispose();
    outputFileController.dispose();
    super.dispose();
  }

  Future<void> selectPrivateKey() async {
    final String? selectedPath = await fileService.pickFileFromDirectory(sshDirectory);
    if (selectedPath == null) return;

    setState(() {
      privateKeyPath = selectedPath;
      privateKeyController.text = p.basename(selectedPath);
    });
  }

  Future<void> selectFileToDecrypt() async {
    final String? selectedPath = await fileService.pickFileFromDirectory(parentOfCurrentDirectory);
    if (selectedPath == null) return;

    setState(() {
      fileToDecryptPath = selectedPath;
      encryptedFileController.text = p.basename(selectedPath);
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

  Future<void> handleDecrypt() async {
    if (privateKeyPath == null || fileToDecryptPath == null || outputFilePath == null) {
      showError(context, 'Selecciona todos los campos');
      return;
    }

    try {
      await cryptoService.decryptFile(
        inputFilePath: fileToDecryptPath!,
        privateKeyPath: privateKeyPath!,
        outputFilePath: outputFilePath!,
      );

      if (!mounted) return;
      showMessage(context, 'Archivo desencriptado con éxito en: ${p.basename(outputFilePath!)}');
    } catch (error) {
      debugPrint('$error');

      if (!mounted) return;
      showError(context, 'Error al desencriptar: $error');
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
                Icon(Icons.lock_open_outlined, color: Colors.deepPurpleAccent),
                SizedBox(width: 8),
                Text(
                  'Desencriptar',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 24),
            FilePickerRow(
              label: 'Clave privada (RSA):',
              controller: privateKeyController,
              onSelect: selectPrivateKey,
              icon: Icons.key_outlined,
            ),
            const SizedBox(height: 16),
            FilePickerRow(
              label: 'Archivo encriptado:',
              controller: encryptedFileController,
              onSelect: selectFileToDecrypt,
              icon: Icons.enhanced_encryption_outlined,
            ),
            const SizedBox(height: 16),
            FilePickerRow(
              label: 'Archivo desencriptado (Destino):',
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
                onPressed: handleDecrypt,
                icon: const Icon(Icons.lock_open),
                label: const Text('Desencriptar archivo'),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
