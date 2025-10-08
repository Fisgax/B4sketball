import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

class AssinaturaPad extends StatefulWidget {
  final Function(Uint8List) onSave;

  const AssinaturaPad({super.key, required this.onSave});

  @override
  State<AssinaturaPad> createState() => _AssinaturaPadState();
}

class _AssinaturaPadState extends State<AssinaturaPad> {
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Assinatura')),
      body: Column(
        children: [
          Expanded(
            child: Signature(
              controller: _controller,
              backgroundColor: Colors.white,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () => _controller.clear(),
                child: const Text('Limpar'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_controller.isNotEmpty) {
                    final image = await _controller.toImage();
                    if (image == null) return;

                    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
                    if (byteData == null) return;

                    final Uint8List pngBytes = byteData.buffer.asUint8List();
                    widget.onSave(pngBytes);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
