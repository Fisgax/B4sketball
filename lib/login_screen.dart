import 'package:flutter/material.dart';
import 'dados_licencas.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/basket_fundo.png', // <- Certifica-te que está no pubspec.yaml
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '🏀 B4sketBall',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 40),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'Licença',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'Palavra-passe',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      final licenca = _usernameController.text.trim();
                      final password = _passwordController.text.trim();

                      // Valida apenas se a licença existir (simples)
                      if (licencasENomes.containsKey(licenca)) {
                        // (Opcional) validar password se quiseres, aqui passa sempre
                        Navigator.pushReplacementNamed(context, '/dadosJogo');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Licença inválida.')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    ),
                    child: const Text('Entrar'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
