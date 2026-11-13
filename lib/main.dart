//NOME: Luciara Pereira

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Receitas App',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: const TelaReceitas(),
    );
  }
}

class TelaReceitas extends StatefulWidget {
  const TelaReceitas({super.key});

  @override
  State<TelaReceitas> createState() => _TelaReceitasState();
}

class _TelaReceitasState extends State<TelaReceitas> {
  final TextEditingController controlador = TextEditingController();

  String pesquisa = '';

  void pesquisar() {
    setState(() {
      pesquisa = controlador.text;
    });
  }

  @override
  void dispose() {
    controlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receitas App - Luciara Pereira'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Pesquise sua receita favorita!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: controlador,
              decoration: const InputDecoration(
                labelText: 'Nome da receita',
                hintText: 'Ex: chicken, pasta, cake',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: pesquisar,
              child: const Text('Buscar receitas'),
            ),

            const SizedBox(height: 20),

            Text(
              pesquisa.isEmpty
                  ? 'Digite o nome de uma receita.'
                  : 'Você pesquisou: $pesquisa',
            ),
          ],
        ),
      ),
    );
  }
}

