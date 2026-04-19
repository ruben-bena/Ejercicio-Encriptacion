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

  final TextEditingController publicKeyController = TextEditingController();
  final TextEditingController fileController = TextEditingController();

  @override
  void dispose() {
    publicKeyController.dispose();
    fileController.dispose();
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

  Future<void> handleEncrypt() async {
    if (publicKeyPath == null || fileToEncryptPath == null) {
      showMessage(context, 'Selecciona todos los archivos primero');
      return;
    }

    final String outputFilePath = '$fileToEncryptPath.enc';

    try {
      await cryptoService.encryptFile(
        inputFilePath: fileToEncryptPath!,
        publicKeyPath: publicKeyPath!,
        outputFilePath: outputFilePath,
      );

      if (!mounted) return;
      showMessage(context, '¡Archivo encriptado en: ${p.basename(outputFilePath)}!');
    } catch (error) {
      debugPrint('$error');

      if (!mounted) return;
      showError(context, 'Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Encriptar', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 20),
            FilePickerRow(
              label: 'Clave pública (RSA):',
              controller: publicKeyController,
              onSelect: selectPublicKey,
            ),
            const SizedBox(height: 16),
            FilePickerRow(
              label: 'Archivo a encriptar:',
              controller: fileController,
              onSelect: selectFileToEncrypt,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: handleEncrypt,
                child: const Text('Encripta Archivo'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
