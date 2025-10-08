import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'intervenientes.dart';

class DadosJogoScreen extends StatefulWidget {
  const DadosJogoScreen({super.key});

  @override
  State<DadosJogoScreen> createState() => _DadosJogoScreenState();
}

class _DadosJogoScreenState extends State<DadosJogoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _provaController = TextEditingController();
  final _jogoNumeroController = TextEditingController();
  final _localController = TextEditingController();
  final _dataController = TextEditingController();
  final _equipaCasaController = TextEditingController();
  final _equipaVisitanteController = TextEditingController();

  List<dynamic> _jogos = [];

  @override
  void initState() {
    super.initState();
    _carregarCalendarioFPB();
  }

  // === Carrega o ficheiro de jogos (online + fallback local) ===
  Future<void> _carregarCalendarioFPB() async {
    const urlOnline =
        'https://raw.githubusercontent.com/Fisgax/B4sketball/main/data/calendario_fpb_completo.json';

    try {
      final resposta = await http.get(Uri.parse(urlOnline)).timeout(const Duration(seconds: 8));
      if (resposta.statusCode == 200) {
        setState(() => _jogos = json.decode(resposta.body));
        debugPrint('✅ Jogos carregados da internet (${_jogos.length})');
        return;
      }
    } catch (_) {
      debugPrint('⚠️ Falha ao carregar online, a usar fallback local...');
    }

    // fallback local
    try {
      final localJson = await rootBundle.loadString('assets/calendario_fpb_completo.json');
      setState(() => _jogos = json.decode(localJson));
      debugPrint('📁 Jogos carregados localmente (${_jogos.length})');
    } catch (e) {
      debugPrint('❌ Erro a carregar fallback: $e');
    }
  }

  // === Sugere automaticamente o jogo com base no local e data ===
  Future<void> _tentarSugestaoAutomatica() async {
    if (_jogos.isEmpty) return;

    final local = _localController.text.toLowerCase().trim();
    final data = _dataController.text.trim();

    final candidatos = _jogos.where((jogo) {
      final localJogo = (jogo['local'] ?? '').toString().toLowerCase();
      final dataJogo = (jogo['data'] ?? '').toString().trim();
      return localJogo.contains(local) && dataJogo.contains(data);
    }).toList();

    if (candidatos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nenhum jogo correspondente encontrado.')),
      );
      return;
    }

    if (candidatos.length == 1) {
      _preencherCamposComJogo(candidatos.first);
    } else {
      _mostrarSelecaoDeJogo(candidatos);
    }
  }

  void _preencherCamposComJogo(Map<String, dynamic> jogo) {
    setState(() {
      _provaController.text = jogo['prova'] ?? '';
      _jogoNumeroController.text = jogo['numero']?.toString() ?? '';
      _localController.text = jogo['local'] ?? '';
      _dataController.text = jogo['data'] ?? '';
      _equipaCasaController.text = jogo['equipa_casa'] ?? '';
      _equipaVisitanteController.text = jogo['equipa_visitante'] ?? '';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Jogo preenchido automaticamente ✅')),
    );
  }

  void _mostrarSelecaoDeJogo(List<dynamic> jogos) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Selecione o jogo correto'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: ListView.builder(
            itemCount: jogos.length,
            itemBuilder: (context, i) {
              final j = jogos[i];
              return ListTile(
                title: Text('${j['equipa_casa']} vs ${j['equipa_visitante']}'),
                subtitle: Text('${j['prova']} — ${j['data']}'),
                onTap: () {
                  Navigator.pop(context);
                  _preencherCamposComJogo(Map<String, dynamic>.from(j));
                },
              );
            },
          ),
        ),
      ),
    );
  }

  // === Função para preencher a data atual ===
  void _preencherDataAtual() {
    final agora = DateTime.now();
    final dataFormatada =
        '${agora.year}-${_doisDigitos(agora.month)}-${_doisDigitos(agora.day)}';
    setState(() {
      _dataController.text = dataFormatada;
    });
  }

  String _doisDigitos(int valor) => valor.toString().padLeft(2, '0');

  // === Localização automática ===
  Future<void> _preencherLocalizacaoAtual() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Serviços de localização estão desativados.')),
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Permissão de localização negada.')),
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Permissões de localização permanentemente negadas.')),
        );
        return;
      }

      final posicao =
          await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      final placemarks =
          await placemarkFromCoordinates(posicao.latitude, posicao.longitude);
      final lugar = placemarks.first;
      final nomeLocal = lugar.subLocality?.isNotEmpty == true
          ? lugar.subLocality
          : lugar.locality ?? 'Localização desconhecida';

      setState(() {
        _localController.text = nomeLocal ?? 'Desconhecido';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao obter localização: $e')),
      );
    }
  }

  // === Google Maps ===
  Future<void> _abrirGoogleMaps() async {
    final destino = _localController.text.trim();
    if (destino.isEmpty) return;

    final uri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(destino)}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível abrir o Google Maps.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dados do Jogo')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _provaController,
              decoration: const InputDecoration(labelText: 'Prova'),
              validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
            ),
            TextFormField(
              controller: _jogoNumeroController,
              decoration: const InputDecoration(labelText: 'Jogo Nº'),
              validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _localController,
                    decoration: const InputDecoration(labelText: 'Local'),
                    validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.my_location),
                  onPressed: _preencherLocalizacaoAtual,
                  tooltip: 'Obter localização atual',
                ),
                IconButton(
                  icon: const Icon(Icons.map),
                  onPressed: _abrirGoogleMaps,
                  tooltip: 'Abrir Google Maps',
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _dataController,
                    decoration: const InputDecoration(labelText: 'Data'),
                    validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: _preencherDataAtual,
                  tooltip: 'Usar data atual',
                ),
              ],
            ),
            TextFormField(
              controller: _equipaCasaController,
              decoration: const InputDecoration(labelText: 'Equipa da Casa'),
              validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
            ),
            TextFormField(
              controller: _equipaVisitanteController,
              decoration: const InputDecoration(labelText: 'Equipa Visitante'),
              validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _tentarSugestaoAutomatica,
              icon: const Icon(Icons.search),
              label: const Text('Sugestão automática FPB'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IntervenientesScreen(
                        prova: _provaController.text,
                        jogoNumero: _jogoNumeroController.text,
                        local: _localController.text,
                        data: _dataController.text,
                        equipaCasa: _equipaCasaController.text,
                        equipaVisitante: _equipaVisitanteController.text,
                      ),
                    ),
                  );
                }
              },
              child: const Text('Seguinte'),
            ),
          ],
        ),
      ),
    );
  }
}
