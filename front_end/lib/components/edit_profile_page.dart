import 'package:flutter/material.dart';
import 'package:front_end/services/api_services.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final nomeController = TextEditingController();
  final idadeController = TextEditingController();
  final alturaController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final confirmarSenhaController = TextEditingController();

  bool loading = true;

  static const preto = Color(0xFF1A1413);
  static const laranja = Color(0xFFED5223);
  static const branco = Color(0xFFFDFDFD);

  @override
  void initState() {
    super.initState();
    carregarUsuario();
  }

  // 🔥 BUSCA DADOS ATUAIS
  void carregarUsuario() async {
    final user = await ApiService.getProfile();

    if (user != null) {
      nomeController.text = user["nome"];
      idadeController.text = user["idade"].toString();
      emailController.text = user["email"];
      alturaController.text = user["altura"].toString();
    }

    setState(() => loading = false);
  }

  // 🔥 SALVAR NO BACKEND
  void salvar() async {
    setState(() => loading = true);

    final response = await ApiService.put(
      "/auth/editar-me",
      {
        "nome": nomeController.text,
        "idade": int.tryParse(idadeController.text) ?? 0,
        "email": emailController.text,
        "altura": double.tryParse(alturaController.text) ?? 0,
        "posicao_preferida": "ala", // ⚠️ ajuste depois
        "senha": senhaController.text,
        "confirmar_senha": confirmarSenhaController.text
      },
    );

    setState(() => loading = false);

    if (response) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Perfil atualizado com sucesso")),
      );

      Navigator.pop(context, true); // 👈 força reload no profile
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao atualizar perfil")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        backgroundColor: preto,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: preto,
      appBar: AppBar(
        title: const Text("Editar Perfil"),
        backgroundColor: preto,
        foregroundColor: laranja,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: nomeController,
                style: const TextStyle(color: branco),
                decoration: const InputDecoration(
                  labelText: "Nome",
                  labelStyle: TextStyle(color: branco),
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: idadeController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: branco),
                decoration: const InputDecoration(
                  labelText: "Idade",
                  labelStyle: TextStyle(color: branco),
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: emailController,
                style: const TextStyle(color: branco),
                decoration: const InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(color: branco),
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: alturaController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: branco),
                decoration: const InputDecoration(
                  labelText: "Altura",
                  labelStyle: TextStyle(color: branco),
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: senhaController,
                obscureText: true,
                style: const TextStyle(color: branco),
                decoration: const InputDecoration(
                  labelText: "Nova senha",
                  labelStyle: TextStyle(color: branco),
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: confirmarSenhaController,
                obscureText: true,
                style: const TextStyle(color: branco),
                decoration: const InputDecoration(
                  labelText: "Confirmar senha",
                  labelStyle: TextStyle(color: branco),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: salvar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: laranja,
                  ),
                  child: const Text(
                    "Salvar",
                    style: TextStyle(color: branco),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}