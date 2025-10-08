import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';

Future<String> gerarPDF(Map<String, dynamic> dados) async {
  final pdf = pw.Document();

  final List<Map<String, String>> interv = List<Map<String, String>>.from(dados['intervenientes']);

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('🏀 Recibo de Jogo', style: pw.TextStyle(fontSize: 24)),
          pw.SizedBox(height: 10),
          pw.Text('Prova: ${dados['prova']}'),
          pw.Text('Jogo nº: ${dados['jogoNumero']}'),
          pw.Text('Local: ${dados['local']}'),
          pw.Text('Data: ${dados['data']}'),
          pw.Text('Escalão: ${dados['escalao']}'),
          pw.SizedBox(height: 20),
          pw.Text('Intervenientes:', style: pw.TextStyle(fontSize: 18)),
          pw.SizedBox(height: 10),
          for (var item in interv) ...[
            pw.Text('${item['função']} - ${item['nome']} (${item['licença']})'),
            pw.Text(
              'Prémio: ${item['prémio']}€ | Deslocação: ${item['deslocação']}€ | Total: ${item['total']}€',
              style: pw.TextStyle(fontSize: 12),
            ),
            pw.Divider(),
          ]
        ],
      ),
    ),
  );

  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/recibo_gerado.pdf');
  await file.writeAsBytes(await pdf.save());

  return file.path;
}
