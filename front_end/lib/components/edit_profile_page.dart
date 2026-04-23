import 'package:flutter/material.dart';
import 'package:front_end/modules/models/jogador.dart';

class EditProfilePage extends StatefulWidget {
  final Jogador? jogador;

  const EditProfilePage({super.key, this.jogador});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nomeController;
  late TextEditingController idadeController;
  late TextEditingController alturaController;
  late TextEditingController emailController;

  static const preto = Color(0xFF1A1413);
  static const laranja = Color(0xFFED5223);
  static const branco = Color(0xFFFDFDFD);

  @override
  void initState() {
    super.initState();
    nomeController = TextEditingController(text: widget.jogador?.nome ?? "");
    idadeController = TextEditingController(
      text: widget.jogador?.idade.toString() ?? "",
    );
    emailController = TextEditingController(
      text: widget.jogador?.email ?? ""
    );
    alturaController = TextEditingController(
      text: widget.jogador?.altura.toString() ?? ""
    );
  }

  void salvar() {
    if (widget.jogador == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Nenhum jogador carregado")));
      return;
    }
    widget.jogador!.nome = nomeController.text;
    widget.jogador!.idade = int.tryParse(idadeController.text) ?? 0;
    widget.jogador!.email = emailController.text;
    widget.jogador!.altura = double.tryParse(alturaController.text) ?? 0.0;
    Navigator.pop(context, widget.jogador);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: preto,
      appBar: AppBar(
        title: Text(
          "Editar Perfil",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: preto,
        foregroundColor: laranja,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: 60,),
              TextField(
                controller: nomeController,
                decoration: InputDecoration(
                  labelText: "Nome:",
                  labelStyle: TextStyle(color: branco),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16)
                  )
                  ),
              ),
              SizedBox(height: 13),
        
              TextField(
                controller: idadeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Idade:",
                  labelStyle: TextStyle(color: branco),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16)
                  )
        
                  ),
              ),
              SizedBox(height: 13),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "E-mail:",
                  labelStyle: TextStyle(color: branco),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16)
                  )
                  ),
              ),
              SizedBox(height: 13),
              TextField(
                controller: alturaController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Altura",
                  labelStyle: TextStyle(color: branco),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16)
                  )
                  ),
              ),
              SizedBox(height: 300),
        
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: salvar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: laranja
                  ), 
                  child: Text(
                    "Salvar",
                  style: TextStyle(
                    color: branco,
                    fontSize: 18
                  ),),
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
