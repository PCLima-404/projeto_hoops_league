// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:front_end/services/api_services.dart';
import 'package:front_end/components/profile_page.dart';
import 'package:front_end/components/buscar_partida_page.dart';

class BuscarJogadorPage extends StatefulWidget {
  final bool modoConvite;

  const BuscarJogadorPage({super.key, this.modoConvite = false});

  @override
  State<BuscarJogadorPage> createState() => _BuscarPageState();
}

class _BuscarPageState extends State<BuscarJogadorPage> {
  final TextEditingController searchController = TextEditingController();

  static const preto = Color(0xFF1A1413);
  static const laranja = Color(0xFFED5223);
  static const branco = Color(0xFFFDFDFD);

  List<dynamic> jogadores = [];
  bool loading = false;

  // 🔥 BUSCA REAL
  void buscar(String texto) async {
    if (texto.isEmpty) {
      setState(() => jogadores = []);
      return;
    }

    setState(() => loading = true);

    final response = await ApiService.get("/auth/buscar-usuario/$texto");

    setState(() {
      jogadores = response ?? [];
      loading = false;
    });
  }

  Widget cardJogador(dynamic jogador) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: branco,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: laranja,
          child: Icon(Icons.person, color: branco),
        ),
        title: Text(
          jogador["user"],
          style: const TextStyle(
            color: laranja,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          jogador["nome"],
          style: const TextStyle(color: Colors.black),
        ),
        trailing: Text(
          "OVR ${jogador["overall"]}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProfilePage()),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: preto,
      appBar: AppBar(
        title: const Text("Buscar Jogadores"),
        backgroundColor: laranja,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              onChanged: buscar,
              decoration: InputDecoration(
                filled: true,
                fillColor: branco,
                hintText: "Buscar jogador...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            if (loading)
              const CircularProgressIndicator(),

            Expanded(
              child: jogadores.isEmpty
                  ? const Center(
                      child: Text(
                        "Digite para buscar",
                        style: TextStyle(color: branco),
                      ),
                    )
                  : ListView.builder(
                      itemCount: jogadores.length,
                      itemBuilder: (context, index) {
                        return cardJogador(jogadores[index]);
                      },
                    ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: laranja,
        selectedItemColor: branco,
        unselectedItemColor: branco,
        currentIndex: 2,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => BuscarPartidaPage()),
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