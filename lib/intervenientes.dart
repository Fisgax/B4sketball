import 'package:flutter/material.dart';
import 'resumo_total.dart';
import 'assinatura_pad.dart';
import 'dart:typed_data';
import 'dados_licencas.dart';
import 'dados_premios.dart';
import 'dados_deslocacoes.dart';

class IntervenientesScreen extends StatefulWidget {
  final String prova;
  final String jogoNumero;
  final String local;
  final String data;
  final String equipaCasa;
  final String equipaVisitante;

  const IntervenientesScreen({
    super.key,
    required this.prova,
    required this.jogoNumero,
    required this.local,
    required this.data,
    required this.equipaCasa,
    required this.equipaVisitante,
  });

  @override
  State<IntervenientesScreen> createState() => _IntervenientesScreenState();
}

class _IntervenientesScreenState extends State<IntervenientesScreen> {
  final List<TextEditingController> _licencas = List.generate(5, (_) => TextEditingController());
  final List<String?> _origens = List.generate(5, (_) => null);
  final List<Uint8List?> _assinaturas = List.filled(5, null);
  final List<String> _nomes = List.filled(5, '');

  final List<String> _funcoes = [
    'Árbitro 1',
    'Árbitro 2',
    'Marcador',
    'Cronometrista',
    'Operador 24s',
  ];

  String? escalaoSelecionado = premiosPorEscalao.keys.first;
  String? localDestino; // novo dropdown global

  @override
  Widget build(BuildContext context) {
    final todasCidades = deslocacoes.keys.toList()..sort();

    return Scaffold(
      appBar: AppBar(title: const Text('Intervenientes')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          DropdownButton<String>(
            value: escalaoSelecionado,
            isExpanded: true,
            hint: const Text('Seleciona o escalão'),
            items: premiosPorEscalao.keys.map((String escalao) {
              return DropdownMenuItem<String>(
                value: escalao,
                child: Text(escalao),
              );
            }).toList(),
            onChanged: (String? novoValor) {
              setState(() {
                escalaoSelecionado = novoValor!;
              });
            },
          ),
          const SizedBox(height: 10),
          DropdownButton<String>(
            value: localDestino,
            isExpanded: true,
            hint: const Text('Seleciona o destino do jogo'),
            items: todasCidades.map((cidade) {
              return DropdownMenuItem<String>(
                value: cidade,
                child: Text(cidade),
              );
            }).toList(),
            onChanged: (String? novoDestino) {
              setState(() {
                localDestino = novoDestino;
              });
            },
          ),
          const SizedBox(height: 20),
          for (int i = 0; i < 5; i++) _buildIntervenienteSection(i, todasCidades),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              if (localDestino == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Seleciona o destino do jogo.")),
                );
                return;
              }

              List<Map<String, String>> intervenientes = List.generate(5, (i) {
                final lic = _licencas[i].text;
                final nome = _nomes[i];
                final origem = _origens[i];

                final isArbitro = _funcoes[i].toLowerCase().contains('árbitro');
                final tipoFuncao = isArbitro ? 'Árbitro' : 'Oficial de Mesa';
                final double premio = premiosPorEscalao[escalaoSelecionado]?[tipoFuncao] ?? 0.0;

                // ADICIONE AQUI OS PRINTS PARA DEBUG
                debugPrint('=== DEBUG DESLOCAÇÕES ===');
                debugPrint('Interveniente ${i+1}: ${_funcoes[i]}');
                debugPrint('Origem selecionada: $origem');
                debugPrint('Destino selecionado: $localDestino');

                double deslocacao = 0.0;
                if (origem != null && localDestino != null && deslocacoes.containsKey(origem)) {
                  deslocacao = deslocacoes[origem]?[localDestino!] ?? 0.0;
                }

                final total = premio + deslocacao;

                return {
                  'função': _funcoes[i],
                  'licença': lic,
                  'nome': nome,
                  'origem': origem ?? '',
                  'prémio': premio.toStringAsFixed(2),
                  'deslocação': deslocacao.toStringAsFixed(2),
                  'total': total.toStringAsFixed(2),
                };
              });

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ResumoTotalScreen(
                    prova: widget.prova,
                    jogoNumero: widget.jogoNumero,
                    local: widget.local,
                    data: widget.data,
                    escalao: escalaoSelecionado ?? '',
                    intervenientes: intervenientes,
                    assinaturas: _assinaturas,
                  ),
                ),
              );
            },
            child: const Text('Seguinte'),
          ),
        ],
      ),
    );
  }

  Widget _buildIntervenienteSection(int index, List<String> cidades) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_funcoes[index], style: const TextStyle(fontWeight: FontWeight.bold)),
        TextField(
          controller: _licencas[index],
          decoration: const InputDecoration(labelText: 'Licença'),
          onChanged: (valor) {
            setState(() {
              _nomes[index] = obterNomePorLicenca(valor);
            });
          },
        ),
        if (_nomes[index].isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text('Nome: ${_nomes[index]}', style: const TextStyle(color: Colors.green)),
          ),
        DropdownButton<String>(
          value: _origens[index],
          isExpanded: true,
          hint: const Text('Seleciona a origem'),
          items: cidades.map((cidade) {
            return DropdownMenuItem<String>(
              value: cidade,
              child: Text(cidade),
            );
          }).toList(),
          onChanged: (String? novaOrigem) {
            setState(() {
              _origens[index] = novaOrigem;
            });
          },
        ),
        Row(
          children: [
            ElevatedButton(
              onPressed: () async {
                final resultado = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AssinaturaPad(
                      onSave: (assinatura) {
                        setState(() {
                          _assinaturas[index] = assinatura;
                        });
                      },
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text('✍️ Assinar'),
            ),
            const SizedBox(width: 10),
            if (_assinaturas[index] != null)
              SizedBox(width: 80, height: 40, child: Image.memory(_assinaturas[index]!)),
          ],
        ),
        const Divider(thickness: 1),
      ],
    );
  }
}
