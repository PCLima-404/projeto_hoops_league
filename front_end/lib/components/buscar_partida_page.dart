// ignore_for_file: non_constant_identifier_names, annotate_overrides, avoid_print

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:front_end/components/buscar_jogador_page.dart';
import 'package:front_end/components/cadastro_partida_page.dart';
import 'package:front_end/components/edit_partida_page.dart';
import 'package:front_end/components/profile_page.dart';
import 'package:front_end/modules/models/Partida.dart';

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

  List<Partida> partidas = [
    Partida(
      local: 'Quadra IFBA',
      data: DateTime(2026, 4, 9),
      horario: '12:00',
      jogadores: [],
      ImgUrl:'',
    ), //ISSO TEM QUE MUDAR COM A ADIÇÃO DO BACKEND E BD
    Partida(
      local: 'Quadra CBA',
      data: DateTime(2026, 4, 15),
      horario: '12:00',
      jogadores: [],
      ImgUrl:'',
    ),
    Partida(
      local: 'Quadra dos Mórmons',
      data: DateTime(2026, 7, 14),
      horario: '12:00',
      jogadores: [],
      ImgUrl:'',
    ),
  ];

  List<Partida> filtrados = [];

  List<Partida> selecionados = [];

  List<Partida> recentes = [];

  void initState() {
    super.initState();
    filtrados = [];
  }

  void excluir(Partida partida) {
    setState(() {
      filtrados.removeWhere((p) => p.local == partida.local);
      selecionados.removeWhere((p) => p.local == partida.local);
      recentes.removeWhere((p) => p.local == partida.local);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('partida removida com sucesso'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
      ),
    );
  }

  void buscar(String texto) {
    setState(() {
      if (texto.isEmpty) {
        filtrados = [];
      } else {
        filtrados = partidas
            .where((j) => j.local.toLowerCase().contains(texto.toLowerCase()))
            .toList();

        for (var partida in filtrados) {
          if (!recentes.contains(partida)) {
            recentes.insert(0, partida);
          }
        }
      }
    });
  }

  void editar(Partida partida) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditPartidaPage()),
    );
  }

  Widget CardPartida(Partida partida) {
    final isSelected = selecionados.contains(partida);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selecionados.remove(partida);
          } else {
            selecionados.add(partida);
          }
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? laranja : branco,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(partida.ImgUrl),
                radius: 25,
              ),
              title: Text(
                partida.local,
                style: TextStyle(
                  color: isSelected ? branco : laranja,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => excluir(partida),
                    icon: Icon(Icons.delete, color: laranja),
                  ),
                  IconButton(
                    onPressed: () => editar(partida),
                    icon: Icon(Icons.edit, color: laranja),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today, color: laranja, size: 20),
                  SizedBox(width: 5),
                  Text(
                    "${DateFormat('dd/MM/yyyy').format(partida.data)} ${partida.horario}",
                    style: TextStyle(
                      color: laranja,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Busca Partidas"),
        leading: IconButton(icon: Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),),
        backgroundColor: laranja,
        foregroundColor: branco,
        centerTitle: true,
      ),
      backgroundColor: preto,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: searchController,
                onChanged: buscar,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: branco,
                  hintText: "Buscar",
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.search,
                      color: const Color.fromARGB(255, 8, 100, 238),
                    ),
                    onPressed: () {
                      print(searchController.text);
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 30),

              Text(
                'Partidas recentes',
                style: TextStyle(color: branco, fontSize: 15),
              ),

              SizedBox(height: 15),
              Text(
                "Recentes",
                style: TextStyle(
                  color: branco,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),

              Expanded(
                child: filtrados.isEmpty
                    ? recentes.isEmpty
                          ? Center(
                              child: Text(
                                "Digite para buscar partidas",
                                style: TextStyle(color: branco),
                              ),
                            )
                          : ListView.builder(
                              itemCount: recentes.length,
                              itemBuilder: (context, index) {
                                return CardPartida(recentes[index]);
                              },
                            )
                    : ListView.builder(
                        itemCount: filtrados.length,
                        itemBuilder: (context, index) {
                          return CardPartida(filtrados[index]);
                        },
                      ),
              ),
              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    backgroundColor: laranja,
                    onPressed: () => Navigator.push(
                      context, MaterialPageRoute(
                        builder: (context) => CadastroPartidaPage(),)),
                      child: Icon(Icons.add, color: branco,),
                    
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: laranja,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: branco,
        unselectedItemColor: branco,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: 2,
        onTap: (index) {
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BuscarJogadorPage()),
            );
          }
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BuscarPartidaPage()),
            );
          }

          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          }
        },

        items: [
          BottomNavigationBarItem(icon: Icon(Icons.house, size: 35), label: ''),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_basketball, size: 35),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, size: 35),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined, size: 35),
            label: '',
          ),
        ],
      ),
    );
  }
}
