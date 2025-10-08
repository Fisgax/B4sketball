import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'Servicos/enviar_email_anexo.dart';
import 'Servicos/gerar_excel.dart';
import 'Servicos/gerar_pdf.dart';
import 'package:share_plus/share_plus.dart';

class ResumoTotalScreen extends StatelessWidget {
  final String prova;
  final String jogoNumero;
  final String local;
  final String data;
  final String escalao;
  final List<Map<String, String>> intervenientes;
  final List<Uint8List?> assinaturas;

  const ResumoTotalScreen({
    super.key,
    required this.prova,
    required this.jogoNumero,
    required this.local,
    required this.data,
    required this.escalao,
    required this.intervenientes,
    required this.assinaturas,
  });

  @override
  Widget build(BuildContext context) {
    double totalGeral = 0.0;
    for (var i = 0; i < intervenientes.length; i++) {
      totalGeral += double.tryParse(intervenientes[i]['total'] ?? '0') ?? 0.0;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Resumo & Total')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Prova: $prova'),
            Text('Jogo Nº: $jogoNumero'),
            Text('Local: $local'),
            Text('Data: $data'),
            Text('Escalão: $escalao', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const Divider(),
            const Text('Intervenientes:', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            for (int i = 0; i < intervenientes.length; i++) ...[
              Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: Text('${intervenientes[i]['função']} - ${intervenientes[i]['nome']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Licença: ${intervenientes[i]['licença']}'),
                      Text('Prémio: ${intervenientes[i]['prémio']}€'),
                      Text('Deslocação: ${intervenientes[i]['deslocação']}€'),
                      Text('Total: ${intervenientes[i]['total']}€'),
                      if (assinaturas[i] != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: SizedBox(
                            height: 50,
                            child: Image.memory(assinaturas[i]!),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const Divider(),
            ],
            const SizedBox(height: 20),
            Text(
              '💶 Total Geral: ${totalGeral.toStringAsFixed(2)}€',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.email),
              label: const Text('Enviar por Email'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () async {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => const Center(child: CircularProgressIndicator()),
                );

                try {
                  final excelPath = await gerarExcel({
                    'prova': prova,
                    'jogoNumero': jogoNumero,
                    'local': local,
                    'data': data,
                    'escalao': escalao,
                    'intervenientes': intervenientes,
                    'assinaturas': assinaturas,
                  });

                  final pdfPath = await gerarPDF({
                    'prova': prova,
                    'jogoNumero': jogoNumero,
                    'local': local,
                    'data': data,
                    'escalao': escalao,
                    'intervenientes': intervenientes,
                  });

                  Navigator.pop(context);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EnviarEmailScreen(
                        prova: prova,
                        jogoNumero: jogoNumero,
                        ficheiroPdfPath: pdfPath,
                        ficheiroExcelPath: excelPath,
                      ),
                    ),
                  );
                } catch (e) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao gerar ficheiros: $e')),
                  );
                }
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.share),
              label: const Text('Partilhar ficheiros'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
              onPressed: () async {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => const Center(child: CircularProgressIndicator()),
                );

                try {
                  final excelPath = await gerarExcel({
                    'prova': prova,
                    'jogoNumero': jogoNumero,
                    'local': local,
                    'data': data,
                    'escalao': escalao,
                    'intervenientes': intervenientes,
                    'assinaturas': assinaturas,
                  });

                  final pdfPath = await gerarPDF({
                    'prova': prova,
                    'jogoNumero': jogoNumero,
                    'local': local,
                    'data': data,
                    'escalao': escalao,
                    'intervenientes': intervenientes,
                  });

                  Navigator.pop(context);

                  await Share.shareXFiles(
                    [XFile(pdfPath), XFile(excelPath)],
                    text: '📎 Recibo de jogo gerado pela app B4sketBall.',
                  );

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Partilha concluída com sucesso ✅')),
                    );
                    await Future.delayed(const Duration(seconds: 2));
                    Navigator.popUntil(context, (route) => route.isFirst);
                  }
                } catch (e) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao partilhar ficheiros: $e')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
