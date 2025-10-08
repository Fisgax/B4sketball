import 'dart:typed_data';
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';

Future<String> gerarExcel(Map<String, dynamic> dados) async {
  final excel = Excel.createExcel();
  final Sheet sheet = excel['Recibo'];

  final String prova = dados['prova'];
  final String jogoNumero = dados['jogoNumero'];
  final String local = dados['local'];
  final String data = dados['data'];
  final List<Map<String, String>> intervenientes = List<Map<String, String>>.from(dados['intervenientes']);
  final double totalFinal = _calcularTotalFinal(intervenientes);

  // Cabeçalho - usando TextCellValue para strings
  sheet.cell(CellIndex.indexByString("A1")).value = TextCellValue("Recibo de Jogo");
  sheet.cell(CellIndex.indexByString("A3")).value = TextCellValue("Prova:");
  sheet.cell(CellIndex.indexByString("B3")).value = TextCellValue(prova);
  sheet.cell(CellIndex.indexByString("A4")).value = TextCellValue("Jogo nº:");
  sheet.cell(CellIndex.indexByString("B4")).value = TextCellValue(jogoNumero);
  sheet.cell(CellIndex.indexByString("A5")).value = TextCellValue("Local:");
  sheet.cell(CellIndex.indexByString("B5")).value = TextCellValue(local);
  sheet.cell(CellIndex.indexByString("A6")).value = TextCellValue("Data:");
  sheet.cell(CellIndex.indexByString("B6")).value = TextCellValue(data);

  // Tabela de intervenientes - convertendo para TextCellValue
  sheet.appendRow([
    TextCellValue("Função"), 
    TextCellValue("Licença"), 
    TextCellValue("Nome"), 
    TextCellValue("Origem"), 
    TextCellValue("Prémio"), 
    TextCellValue("Deslocação"), 
    TextCellValue("Total")
  ]);

  for (final item in intervenientes) {
    sheet.appendRow([
      TextCellValue(item['função'] ?? ''),
      TextCellValue(item['licença'] ?? ''),
      TextCellValue(item['nome'] ?? ''),
      TextCellValue(item['origem'] ?? ''),
      TextCellValue(item['prémio'] ?? ''),
      TextCellValue(item['deslocação'] ?? ''),
      TextCellValue(item['total'] ?? ''),
    ]);
  }

  // Total final - convertendo para TextCellValue
  sheet.appendRow([
    TextCellValue(""), 
    TextCellValue(""), 
    TextCellValue(""), 
    TextCellValue(""), 
    TextCellValue(""), 
    TextCellValue("Total Final:"), 
    TextCellValue(totalFinal.toStringAsFixed(2))
  ]);

  // Guardar ficheiro
  final bytes = excel.encode();
  final dir = await getApplicationDocumentsDirectory();
  final file = File("${dir.path}/recibo_gerado.xlsx");
  await file.writeAsBytes(Uint8List.fromList(bytes!));

  return file.path;
}

double _calcularTotalFinal(List<Map<String, String>> intervenientes) {
  double total = 0.0;
  for (final item in intervenientes) {
    total += double.tryParse(item['total'] ?? '0') ?? 0.0;
  }
  return total;
}