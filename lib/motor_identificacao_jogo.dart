import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// Classe que representa um jogo da FPB
class JogoFPB {
  final String competicao;
  final String jogoNum;
  final String data;
  final String hora;
  final String equipaCasa;
  final String equipaFora;
  final String local;

  JogoFPB({
    required this.competicao,
    required this.jogoNum,
    required this.data,
    required this.hora,
    required this.equipaCasa,
    required this.equipaFora,
    required this.local,
  });

  factory JogoFPB.fromJson(Map<String, dynamic> json) {
    return JogoFPB(
      competicao: json['competicao'] ?? '',
      jogoNum: json['jogo_num'] ?? '',
      data: json['data'] ?? '',
      hora: json['hora'] ?? '',
      equipaCasa: json['equipa_casa'] ?? '',
      equipaFora: json['equipa_fora'] ?? '',
      local: json['local'] ?? '',
    );
  }
}

/// Carrega o ficheiro JSON dos jogos da FPB
Future<List<JogoFPB>> carregarCalendarioFPB() async {
  final data = await rootBundle.loadString('assets/calendario_fpb.json');
  final jsonList = jsonDecode(data) as List;
  return jsonList.map((e) => JogoFPB.fromJson(e)).toList();
}

/// Procura o jogo correspondente com base em local, data e hora
Future<JogoFPB?> identificarJogo({
  required String localAtual,
  DateTime? dataAtual,
  int toleranciaHoras = 3,
}) async {
  final jogos = await carregarCalendarioFPB();
  dataAtual ??= DateTime.now();

  // Normaliza o nome do local (acentos, maiúsculas, etc.)
  String normalizar(String s) =>
      s.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');

  final localNorm = normalizar(localAtual);

  // Filtra jogos com local semelhante e data igual
  final jogosMesmoLocal = jogos.where((jogo) {
    final dataJogo = DateFormat('dd/MM/yyyy').parse(jogo.data, true);
    final localJogo = normalizar(jogo.local);
    return (dataJogo.day == dataAtual!.day &&
        dataJogo.month == dataAtual.month &&
        dataJogo.year == dataAtual.year &&
        localJogo.contains(localNorm));
  }).toList();

  if (jogosMesmoLocal.isEmpty) return null;

  // Se houver vários no mesmo local, verifica o horário mais próximo
  JogoFPB? melhor;
  Duration menorDiferenca = const Duration(hours: 99);

  for (var jogo in jogosMesmoLocal) {
    try {
      final horaJogo = DateFormat('HH:mm').parse(jogo.hora);
      final horaComData = DateTime(
        dataAtual.year,
        dataAtual.month,
        dataAtual.day,
        horaJogo.hour,
        horaJogo.minute,
      );
      final diferenca = dataAtual.difference(horaComData).abs();
      if (diferenca < menorDiferenca &&
          diferenca <= Duration(hours: toleranciaHoras)) {
        menorDiferenca = diferenca;
        melhor = jogo;
      }
    } catch (_) {}
  }

  return melhor;
}
