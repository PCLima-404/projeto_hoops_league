// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:front_end/components/buscar_jogador_page.dart';
import 'package:front_end/modules/models/jogador.dart';
import 'package:http/http.dart' as http;
import 'package:front_end/services/api_services.dart';

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
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      locale: const Locale('pt', 'BR'),
    );

    if (picked != null) {
      setState(() => dataSelecionada = picked);
    }
  }


  Future<void> selecionarHora() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      final horaFormatada =
          "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
      setState(() => horaController.text = horaFormatada);
    }
  }

  // ================= BUSCAR JOGADORES =================
  Future<void> irParaBusca() async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const BuscarJogadorPage(modoConvite: true),
      ),
    );

    if (resultado != null && resultado is List<Jogador>) {
      setState(() {
        jogadoresSelecionados = resultado;
      });
    }
  }

  // ================= CRIAR PARTIDA (BACKEND) =================
  Future<void> criarPartida() async {
    if (localController.text.isEmpty ||
        dataSelecionada == null ||
        horaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos")),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse("${ApiService.baseUrl}/jogos/criar"),
        headers: ApiService.headers,
        body: jsonEncode({
          "fk_Competicao_id": 1, // ⚠️ AJUSTAR (ID real da competição)
          "data": DateFormat('yyyy-MM-dd').format(dataSelecionada!),
          "horario": horaController.text
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Partida criada com sucesso")),
        );

        Navigator.pop(context);
      } else {
        print(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erro ao criar partida")),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro de conexão")),
      );
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: preto,
      appBar: AppBar(
        title: const Text("CRIAÇÃO DE PARTIDA"),
        backgroundColor: laranja,
        foregroundColor: branco,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Local", style: TextStyle(color: branco)),
            const SizedBox(height: 5),

            TextField(
              controller: localController,
              style: const TextStyle(color: branco),
              decoration: InputDecoration(
                hintText: "Informe o local",
                hintStyle: const TextStyle(color: branco),
                filled: true,
                fillColor: laranja,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 15),

            const Text("Data do jogo", style: TextStyle(color: branco)),
            const SizedBox(height: 5),

            GestureDetector(
              onTap: selecionarData,
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: laranja,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      dataSelecionada == null
                          ? "Selecionar data"
                          : DateFormat('dd/MM/yyyy').format(dataSelecionada!),
                      style: const TextStyle(color: branco),
                    ),
                    const Icon(Icons.calendar_today, color: branco),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),

            const Text("Horário do jogo", style: TextStyle(color: branco)),
            const SizedBox(height: 5),

            GestureDetector(
              onTap: selecionarHora,
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: laranja,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      horaController.text.isEmpty
                          ? "Selecionar horário"
                          : horaController.text,
                      style: const TextStyle(color: branco),
                    ),
                    const Icon(Icons.access_time, color: branco),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),

            const Text("Jogadores", style: TextStyle(color: branco)),
            const SizedBox(height: 5),

            GestureDetector(
              onTap: irParaBusca,
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: laranja,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text("Convidar jogadores", style: TextStyle(color: branco)),
              ),
            ),

            const SizedBox(height: 15),

            Expanded(
              child: jogadoresSelecionados.isEmpty
                  ? const Center(
                      child: Text(
                        "Nenhum jogador selecionado",
                        style: TextStyle(color: branco),
                      ),
                    )
                  : ListView.builder(
                      itemCount: jogadoresSelecionados.length,
                      itemBuilder: (_, index) {
                        final j = jogadoresSelecionados[index];

                        return ListTile(
                          title: Text(
                            j.nome,
                            style: const TextStyle(color: branco),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                jogadoresSelecionados.removeAt(index);
                              });
                            },
                          ),
                        );
                      },
                    ),
            ),

            const SizedBox(height: 10),

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
                child: const Text(
                  "CRIAR PARTIDA",
                  style: TextStyle(
                    color: preto,
                    fontWeight: FontWeight.bold,
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