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
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
        ),
        useMaterial3: true,
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
  bool carregando = false;
  bool pesquisou = false;
  String mensagemErro = '';

  Future<void> buscarReceitas() async {
    String pesquisa = controlador.text.trim();

    if (pesquisa.isEmpty) {
      setState(() {
        mensagemErro = 'Digite o nome de uma receita.';
        receitas = [];
        pesquisou = false;
      });
      return;
    }

    setState(() {
      carregando = true;
      pesquisou = true;
      mensagemErro = '';
      receitas = [];
    });

    try {
      final url = Uri.https(
        'www.themealdb.com',
        '/api/json/v1/1/search.php',
        {'s': pesquisa},
      );

      final resposta = await http.get(url);

      if (!mounted) return;

      if (resposta.statusCode == 200) {
        final dados = jsonDecode(resposta.body);

        setState(() {
          receitas = dados['meals'] ?? [];
        });
      } else {
        setState(() {
          mensagemErro = 'Erro ao buscar receitas.';
        });
      }
    } catch (erro) {
      if (!mounted) return;

      setState(() {
        mensagemErro = 'Erro de conexão. Tente novamente.';
      });
    } finally {
      if (mounted) {
        setState(() {
          carregando = false;
        });
      }
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
      backgroundColor: const Color(0xFFFFF8F2),

      appBar: AppBar(
        title: const Text(
          'Receitas App - Luciara Pereira',
          style: TextStyle(fontSize: 18),
        ),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(
              Icons.restaurant_menu,
              color: Colors.deepOrange,
              size: 60,
            ),

            const SizedBox(height: 10),

            const Text(
              'Encontre sua receita favorita!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: controlador,
              decoration: InputDecoration(
                labelText: 'Nome da receita',
                hintText: 'Ex: chicken, pasta, cake',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: (_) {
                if (!carregando) {
                  buscarReceitas();
                }
              },
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: carregando ? null : buscarReceitas,
                icon: const Icon(Icons.search),
                label: const Text('Buscar receitas'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(15),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: carregando
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : mensagemErro.isNotEmpty
                      ? Center(
                          child: Text(
                            mensagemErro,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                            ),
                          ),
                        )
                      : receitas.isEmpty
                          ? Center(
                              child: Text(
                                pesquisou
                                    ? 'Nenhuma receita encontrada.'
                                    : 'Pesquise uma receita para começar!',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: receitas.length,
                              itemBuilder: (context, index) {
                                final receita = receitas[index];

                                return Card(
                                  margin: const EdgeInsets.only(
                                    bottom: 12,
                                  ),
                                  child: ListTile(
                                    contentPadding:
                                        const EdgeInsets.all(10),

                                    leading: ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(8),
                                      child: Image.network(
                                        receita['strMealThumb'] ?? '',
                                        width: 75,
                                        height: 75,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Icon(
                                            Icons.broken_image,
                                            size: 45,
                                          );
                                        },
                                      ),
                                    ),

                                    title: Text(
                                      receita['strMeal'] ?? '',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
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