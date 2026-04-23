import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditPartidaPage extends StatefulWidget {
  const EditPartidaPage({super.key});

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

  Future<void> selecionarData() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dataSelecionada ?? DateTime.now(),
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
        horarioController.text = picked.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: preto,
      appBar: AppBar(
        backgroundColor: preto,
        foregroundColor: laranja,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Editar Partida",
          style: TextStyle(color: laranja, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.grey[800],
                    backgroundImage: NetworkImage(
                      "https://instagram.fvdc11-1.fna.fbcdn.net/v/t51.2885-19/472424157_1781634115924753_8980338112308315574_n.jpg?efg=eyJ2ZW5jb2RlX3RhZyI6InByb2ZpbGVfcGljLmRqYW5nby43MDkuYzIifQ&_nc_ht=instagram.fvdc11-1.fna.fbcdn.net&_nc_cat=101&_nc_oc=Q6cZ2gFOR8GmYVSBG7WJcI8su7yXMfvAIGB_UFfKjFsKFpivrcq6QIFsK72PrijMjVDmkLC4HzBLtROlFi2DZjFgw_8Y&_nc_ohc=KeO1JjqcUqMQ7kNvwG0nORw&_nc_gid=v4CVFHHIOt0CrLgRt1SxYg&edm=AP4sbd4BAAAA&ccb=7-5&oh=00_Af21xB1ko36oz_jT1ijO0jEY2qpultsEe9FAvp-wmYwG6w&oe=69DC6455&_nc_sid=7a9f4b",
                    ),
                  ),
                ),
                Text("Local", style: TextStyle(color: branco)),
                SizedBox(height: 5),
                TextFormField(
                  controller: localController,
                  style: TextStyle(color: branco),
                  decoration: InputDecoration(
                    hintText: "Informe o local:",
                    hintStyle: TextStyle(color: branco, fontSize: 14),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.white, // Branco puro
                        width:
                            1.0, // Aumente aqui para dar mais "viva" e destaque
                      ),
                    ),
                    // Borda quando você está digitando no campo
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 1.0, // Pode deixar ainda mais grosso ao focar
                      ),
                    ),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Informe o local" : null,
                ),

                SizedBox(height: 15),

                Text("Data do jogo", style: TextStyle(color: branco)),
                SizedBox(height: 5),
                GestureDetector(
                  onTap: selecionarData,
                  child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: preto,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: branco),
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

                // ── Horário ────────────────────────────────────────────────
                Text("Horário do jogo", style: TextStyle(color: branco)),
                SizedBox(height: 5),
                GestureDetector(
                  onTap: selecionarHora,
                  child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: preto,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: branco),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          horarioController.text.isEmpty
                              ? "Selecionar horário:"
                              : horarioController.text,
                          style: TextStyle(color: branco),
                        ),
                        Icon(Icons.access_time, color: branco),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 200),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: laranja,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: Text(
                      "SALVAR",
                      style: TextStyle(
                        color: preto,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
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
