// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:front_end/services/api_services.dart';
import 'package:front_end/components/profile_page.dart';
import 'package:front_end/components/buscar_jogador_page.dart';
import 'package:front_end/components/cadastro_partida_page.dart';

class BuscarPartidaPage extends StatefulWidget {
  const BuscarPartidaPage({super.key});

  @override
  State<BuscarPartidaPage> createState() => _BuscarPageState();
}

class _BuscarPageState extends State<BuscarPartidaPage> {
  final TextEditingController searchController = TextEditingController();

  static const preto = Color(0xFF1A1413);
  static const laranja = Color(0xFFED5223);
  static const branco = Color(0xFFFDFDFD);

  List<dynamic> partidas = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    carregarPartidas();
  }

  // 🔥 BUSCAR DO BACKEND
  void carregarPartidas() async {
    setState(() => loading = true);

    final response = await ApiService.get("/comp/");

    setState(() {
      partidas = response ?? [];
      loading = false;
    });
  }

  // 🔥 DELETE REAL
  void excluir(int id) async {
    final sucesso = await ApiService.delete("/comp/deletar/$id");

    if (sucesso) {
      carregarPartidas();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Partida deletada")),
      );
    }
  }

  // 🔥 FILTRO LOCAL (APENAS VISUAL)
  List<dynamic> get filtrados {
    final texto = searchController.text;

    if (texto.isEmpty) return partidas;

    return partidas.where((p) {
      return p["local"]
          .toLowerCase()
          .contains(texto.toLowerCase());
    }).toList();
  }

  Widget cardPartida(dynamic partida) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: branco,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              partida["local"],
              style: const TextStyle(
                color: laranja,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: laranja),
              onPressed: () => excluir(partida["id"]),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(color: Colors.grey),
            child: Text(
              "ID: ${partida["id"]}",
              style: const TextStyle(color: branco),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: preto,
      appBar: AppBar(
        title: const Text("Buscar Partidas"),
        backgroundColor: laranja,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                filled: true,
                fillColor: branco,
                hintText: "Buscar partida...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 20),

            if (loading)
              const CircularProgressIndicator(),

            Expanded(
              child: ListView.builder(
                itemCount: filtrados.length,
                itemBuilder: (context, index) {
                  return cardPartida(filtrados[index]);
                },
              ),
            ),

            const SizedBox(height: 10),

            FloatingActionButton(
              backgroundColor: laranja,
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CadastroPartidaPage(),
                  ),
                );

                carregarPartidas(); // 🔥 atualiza ao voltar
              },
              child: const Icon(Icons.add, color: branco),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: laranja,
        selectedItemColor: branco,
        unselectedItemColor: branco,
        currentIndex: 1,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => BuscarJogadorPage()),
            );
          }
          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfilePage()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.sports_basketball), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }
}