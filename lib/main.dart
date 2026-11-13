// Integrante: Luciara Pereira

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  List<dynamic> receitas = [];

  Future<void> buscarReceitas() async {
    String pesquisa = controlador.text.trim();

    if (pesquisa.isEmpty) {
      setState(() {
        receitas = [];
      });
      return;
    }

    final url = Uri.https(
      'www.themealdb.com',
      '/api/json/v1/1/search.php',
      {'s': pesquisa},
    );

    final resposta = await http.get(url);

    if (resposta.statusCode == 200) {
      final dados = jsonDecode(resposta.body);

      if (!mounted) return;

      setState(() {
        receitas = dados['meals'] ?? [];
      });
    }
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
              onPressed: buscarReceitas,
              child: const Text('Buscar receitas'),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: receitas.length,
                itemBuilder: (context, index) {
                  final receita = receitas[index];

                  return Card(
                    child: ListTile(
                      leading: Image.network(
                        receita['strMealThumb'] ?? '',
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.broken_image);
                        },
                      ),
                      title: Text(
                        receita['strMeal'] ?? '',
                      ),
                      subtitle: Text(
                        receita['strCategory'] ?? '',
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}