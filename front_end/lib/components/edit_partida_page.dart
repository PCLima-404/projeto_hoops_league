// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:front_end/services/api_services.dart';

class EditPartidaPage extends StatefulWidget {
  final int jogoId; // 🔥 importante

  const EditPartidaPage({super.key, required this.jogoId});

  @override
  State<EditPartidaPage> createState() => _EditPartidaPageState();
}

class _EditPartidaPageState extends State<EditPartidaPage> {
  static const preto = Color(0xFF1A1413);
  static const laranja = Color(0xFFED5223);
  static const branco = Color(0xFFFDFDFD);

  final TextEditingController localController = TextEditingController();
  final TextEditingController horarioController = TextEditingController();

  DateTime? dataSelecionada;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    carregarDados(); // 🔥 carregar do backend
  }

  // ================= BUSCAR DADOS =================
  Future<void> carregarDados() async {
    try {
      final response = await http.get(
        Uri.parse("${ApiService.baseUrl}/jogos/${widget.jogoId}"),
        headers: ApiService.headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          localController.text = data["local"] ?? "";
          horarioController.text = data["horario"] ?? "";
          dataSelecionada = DateTime.tryParse(data["data"] ?? "");
        });
      }
    } catch (e) {
      print(e);
    }
  }

  // ================= ATUALIZAR =================
  Future<void> salvar() async {
    if (!formKey.currentState!.validate()) return;

    try {
      final response = await http.put(
        Uri.parse("${ApiService.baseUrl}/jogos/${widget.jogoId}"),
        headers: ApiService.headers,
        body: jsonEncode({
          "local": localController.text,
          "data": DateFormat('yyyy-MM-dd').format(dataSelecionada!),
          "horario": horarioController.text
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Partida atualizada")),
        );
        Navigator.pop(context);
      } else {
        print(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erro ao atualizar")),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro de conexão")),
      );
    }
  }

  // ================= DATA =================
  Future<void> selecionarData() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: dataSelecionada ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      locale: const Locale('pt', 'BR'),
    );

    if (picked != null) {
      setState(() => dataSelecionada = picked);
    }
  }

  // ================= HORA =================
  Future<void> selecionarHora() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      final horaFormatada =
          "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
      setState(() => horarioController.text = horaFormatada);
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: preto,
      appBar: AppBar(
        backgroundColor: preto,
        foregroundColor: laranja,
        title: const Text("Editar Partida"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Local", style: TextStyle(color: branco)),
                const SizedBox(height: 5),

                TextFormField(
                  controller: localController,
                  style: const TextStyle(color: branco),
                  decoration: InputDecoration(
                    hintText: "Informe o local",
                    hintStyle: const TextStyle(color: branco),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: branco),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: branco),
                    ),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Informe o local" : null,
                ),

                const SizedBox(height: 15),

                const Text("Data", style: TextStyle(color: branco)),
                const SizedBox(height: 5),

                GestureDetector(
                  onTap: selecionarData,
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      border: Border.all(color: branco),
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

                const Text("Horário", style: TextStyle(color: branco)),
                const SizedBox(height: 5),

                GestureDetector(
                  onTap: selecionarHora,
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      border: Border.all(color: branco),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          horarioController.text.isEmpty
                              ? "Selecionar horário"
                              : horarioController.text,
                          style: const TextStyle(color: branco),
                        ),
                        const Icon(Icons.access_time, color: branco),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: salvar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: laranja,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: const Text(
                      "SALVAR",
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
        ),
      ),
    );
  }
}