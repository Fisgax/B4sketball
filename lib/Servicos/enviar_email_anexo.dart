import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'dart:io';

class EnviarEmailScreen extends StatefulWidget {
  final String prova;
  final String jogoNumero;
  final String ficheiroPdfPath;
  final String ficheiroExcelPath;

  const EnviarEmailScreen({
    super.key,
    required this.prova,
    required this.jogoNumero,
    required this.ficheiroPdfPath,
    required this.ficheiroExcelPath,
  });

  @override
  State<EnviarEmailScreen> createState() => _EnviarEmailScreenState();
}

class _EnviarEmailScreenState extends State<EnviarEmailScreen> {
  final TextEditingController emailController = TextEditingController();
  late TextEditingController assuntoController;
  final TextEditingController mensagemController = TextEditingController(
    text: "Segue em anexo o recibo gerado pela app B4sketBall (PDF + Excel).",
  );

  @override
  void initState() {
    super.initState();
    assuntoController = TextEditingController(
      text: "Recibo de Jogo – ${widget.prova} Jogo nº ${widget.jogoNumero}",
    );
  }

  Future<void> enviarEmail() async {
    final Email email = Email(
      body: mensagemController.text,
      subject: assuntoController.text,
      recipients: [emailController.text],
      attachmentPaths: [
        widget.ficheiroPdfPath,
        widget.ficheiroExcelPath,
      ],
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao enviar email: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enviar por Email')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email do Destinatário'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: assuntoController,
              decoration: const InputDecoration(labelText: 'Assunto'),
            ),
            TextField(
              controller: mensagemController,
              decoration: const InputDecoration(labelText: 'Mensagem'),
              maxLines: 5,
            ),
            const SizedBox(height: 10),
            Text(
              "📎 Anexos: ${_nome(widget.ficheiroPdfPath)}, ${_nome(widget.ficheiroExcelPath)}",
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: enviarEmail,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text("Enviar Email"),
            )
          ],
        ),
      ),
    );
  }

  String _nome(String path) => path.split(Platform.pathSeparator).last;
}
