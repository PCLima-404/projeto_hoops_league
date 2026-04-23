// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:front_end/components/buscar_jogador_page.dart';
import 'package:front_end/modules/models/jogador.dart';
import 'package:front_end/modules/models/partida.dart';

class CadastroPartidaPage extends StatefulWidget {
  const CadastroPartidaPage({super.key});

  @override
  State<CadastroPartidaPage> createState() => _CadastroPartidaPageState();
}

class _CadastroPartidaPageState extends State<CadastroPartidaPage> {
  static const preto = Color(0xFF1A1413);
  static const laranja = Color(0xFFED5223);
  static const branco = Color(0xFFFDFDFD);

  final localController = TextEditingController();
  final horaController = TextEditingController();

  DateTime? dataSelecionada;

  List<Jogador> jogadoresSelecionados = [];

  Future<void> selecionarData() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2026),
      lastDate: DateTime(4200),
      locale: Locale('pt', 'BR'),
    );

    if (picked != null) {
      setState(() {
        dataSelecionada = picked;
      });
    }
  }

  Future<void> selecionarHora() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        horaController.text = picked.format(context);
      });
    }
  }

  Future<void> irParaBusca() async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BuscarJogadorPage(modoConvite: true),
      ),
    );

    if (resultado != null && resultado is List<Jogador>) {
      setState(() {
        jogadoresSelecionados.addAll(resultado);
      });
    }
  }

  void criarPartida() {
    if (localController.text.isEmpty ||
        dataSelecionada == null ||
        horaController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Preencha todos os campos")));
      return;
    }
    late final partida = Partida(
      local: localController.text,
      data: dataSelecionada!,
      horario: horaController.text,
      jogadores: jogadoresSelecionados,
    );
    print("Partida criada");
    print(partida.local);
    print(partida.data);
    print(partida.horario);
    print(jogadoresSelecionados.map((j) => j.nome).toList());

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Partida criada com sucesso")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: preto,
      appBar: AppBar(
        title: Text("CRIAÇÃO DE PARTIDA"),
        backgroundColor: laranja,
        foregroundColor: branco,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Local", style: TextStyle(color: branco)),
            SizedBox(height: 5),

            TextField(
              controller: localController,
              decoration: InputDecoration(
                hintText: "Informe a local:",
                hintStyle: TextStyle(color: branco, fontSize: 14),
                filled: true,
                fillColor: laranja,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            SizedBox(height: 15),

            Text("Data do jogo", style: TextStyle(color: branco)),
            SizedBox(height: 5),

            GestureDetector(
              onTap: selecionarData,
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: laranja,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      dataSelecionada == null
                          ? "Selecionar data:"
                          : 'Data Selecionada: ${DateFormat('dd/MM/y').format(dataSelecionada!)}',
                      style: TextStyle(color: branco),
                    ),
                    Icon(Icons.calendar_today, color: branco),
                  ],
                ),
              ),
            ),

            SizedBox(height: 15),

            Text("Horário do jogo", style: TextStyle(color: branco)),
            SizedBox(height: 5),

            GestureDetector(
              onTap: selecionarHora,
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: laranja,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      horaController.text.isEmpty
                          ? "Selecionar horário:"
                          : horaController.text,
                      style: TextStyle(color: branco),
                    ),
                    Icon(Icons.access_time, color: branco),
                  ],
                ),
              ),
            ),

            SizedBox(height: 15),

            Text("Jogadores Convidados", style: TextStyle(color: branco)),
            SizedBox(height: 5),

            GestureDetector(
              onTap: irParaBusca,
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: laranja,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text("Convidar...", style: TextStyle(color: branco)),
              ),
            ),

            SizedBox(height: 15),

            Expanded(
              child: jogadoresSelecionados.isEmpty
                  ? Center(
                      child: Text(
                        "Nenhum jogador selecionado",
                        style: TextStyle(color: branco),
                      ),
                    )
                  : ListView.builder(
                      itemCount: jogadoresSelecionados.length,
                      itemBuilder: (context, index) {
                        final jogador = jogadoresSelecionados[index];

                        return Container(
                          margin: EdgeInsets.only(bottom: 6),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: preto),
                          ),
                          child: ListTile(
                            title: Text(
                              jogador.nome.toUpperCase(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                letterSpacing: 1.2,
                              ),
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                setState(() {
                                  jogadoresSelecionados.remove(jogador);
                                });
                              },
                              icon: Icon(Icons.close, color: Colors.red),
                            ),
                          ),
                        );
                      },
                    ),
            ),

            SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: criarPartida,
                style: ElevatedButton.styleFrom(
                  backgroundColor: laranja,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  "CRIA PARTIDA",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: preto,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
