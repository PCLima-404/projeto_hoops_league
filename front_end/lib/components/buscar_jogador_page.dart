// ignore_for_file: non_constant_identifier_names, annotate_overrides, avoid_print

import 'package:flutter/material.dart';
import 'package:front_end/components/buscar_partida_page.dart';
import 'package:front_end/components/edit_profile_page.dart';
import 'package:front_end/components/profile_page.dart';
import 'package:front_end/modules/models/jogador.dart';

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

  List<Jogador> Jogadores = [
    Jogador(
      nome: 'Pedro Cesar',
      usuario: 'PC',
      overall: 80,
      ImgUrl:'',
      idade: 21,
      email: "jogador@mail.com",
      altura: 1.70
    ), //ISSO TEM QUE MUDAR COM A ADIÇÃO DO BACKEND E BD
    Jogador(
      nome: 'Eduardo',
      usuario: 'Dudas',
      overall: 80,
      ImgUrl:'',
      idade: 22,
      email: "jogador@mail.com",
      altura: 1.70
    ),
    Jogador(
      nome: 'Gabriel',
      usuario: 'Risadas',
      overall: 80,
      ImgUrl:'',
      idade: 21,
      email: "jogador@mail.com",
      altura: 1.70
    ),
  ];

  List<Jogador> filtrados = [];

  List<Jogador> selecionados = [];

  List<Jogador> recentes = [];

  void initState() {
    super.initState();
    filtrados = [];
  }

  void excluir(Jogador jogador) {
    setState(() {
      recentes.remove(jogador);
      filtrados.remove(jogador);
      selecionados.remove(jogador);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('jogador removido com sucesso'),
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
        filtrados = Jogadores.where(
          (j) => j.usuario.toLowerCase().contains(texto.toLowerCase()),
        ).toList();

        for (var jogador in filtrados) {
          if (!recentes.contains(jogador)) {
            recentes.insert(0, jogador);
          }
        }
      }
    });
  }

  void editar(Jogador jogador) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(jogador: jogador),
      ),
    );
  }

  Widget CardJogador(Jogador jogador) {
    final isSelected = selecionados.contains(jogador);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selecionados.remove(jogador);
          } else {
            selecionados.add(jogador);
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
                backgroundImage: NetworkImage(jogador.ImgUrl),
                radius: 25,
              ),
              title: Text(
                jogador.usuario,
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
                    onPressed: () => excluir(jogador),
                    icon: Icon(Icons.delete, color: laranja),
                  ),
                  IconButton(
                    onPressed: () => editar(jogador),
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
                  Icon(Icons.star, color: laranja, size: 20),
                  SizedBox(width: 5),
                  Text(
                    "Overall: ${jogador.overall}",
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
        title: Text("Busca Jogadores"),
        leading: IconButton(icon: Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),),
        backgroundColor: laranja,
        foregroundColor: branco,
        centerTitle: true,
      ),
      backgroundColor: preto,
      floatingActionButton: widget.modoConvite
          ? FloatingActionButton(
              backgroundColor: laranja,
              onPressed: () {
                Navigator.pop(context, selecionados);
              },
              child: Icon(Icons.check, color: branco),
            )
          : null,

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
                'Jogadores recentes',
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
                                "Digite para buscar jogadores",
                                style: TextStyle(color: branco),
                              ),
                            )
                          : ListView.builder(
                              itemCount: recentes.length,
                              itemBuilder: (context, index) {
                                return CardJogador(recentes[index]);
                              },
                            )
                    : ListView.builder(
                        itemCount: filtrados.length,
                        itemBuilder: (context, index) {
                          return CardJogador(filtrados[index]);
                        },
                      ),
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
