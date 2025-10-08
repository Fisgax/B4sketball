import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'dados_jogo.dart';
import 'splash_login.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'B4sketBall',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashLogin(),
        '/login': (context) => LoginScreen(),
        '/dadosJogo': (context) => const DadosJogoScreen(),
      },
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recibos Basket')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.sports_basketball, size: 100, color: Colors.deepOrange),
            const SizedBox(height: 20),
            const Text("Bem-vindo à App Recibos Basket!", style: TextStyle(fontSize: 20)),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DadosJogoScreen()),
                );
              },
              child: const Text("Começar"),
            ),
          ],
        ),
      ),
    );
  }
}