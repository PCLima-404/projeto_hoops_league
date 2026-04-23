// ignore_for_file: use_key_in_widget_constructors
import 'package:front_end/components/position_page.dart';
import 'package:flutter/material.dart';
import 'package:front_end/services/api_services.dart'; // 👈 IMPORTANTE

class CadastroPage extends StatefulWidget {
  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordconfirmController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  static const preto = Color(0xFF1A1413);
  static const laranja = Color(0xFFED5223);
  static const branco = Color(0xFFFDFDFD);

  bool obscurePassword = true;
  bool obscurePasswordConfirmar = true;
  bool loading = false;


void cadastro() async {
  if (formKey.currentState!.validate()) {
    final sucesso = await ApiService.register({
      "user": userController.text,
      "nome": nomeController.text,
      "email": emailController.text,
      "senha": passwordController.text,
      "confirmar_senha": passwordconfirmController.text,
      "idade": 0, // depois vamos preencher
      "altura": 0.0,
      "posicao_preferida": "nao_sei"
    });

    if (sucesso) {
      await ApiService.login(emailController.text, passwordController.text);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => PositionPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao cadastrar")),
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: preto,
      appBar: AppBar(
        backgroundColor: preto,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: laranja),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Criar conta",
                  style: TextStyle(
                    color: laranja,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),

                Text(
                  "Quer se desafiar e entrar para a elite do basquete amador?",
                  style: TextStyle(color: branco),
                ),

                SizedBox(height: 15),

                // NOME
                TextFormField(
                  controller: nomeController,
                  style: TextStyle(color: branco),
                  decoration: InputDecoration(
                    labelText: "Nome",
                    labelStyle: TextStyle(color: branco),
                    prefixIcon: Icon(Icons.person, color: branco),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Informe o nome" : null,
                ),

                SizedBox(height: 15),

                // USER
                TextFormField(
                  controller: userController,
                  style: TextStyle(color: branco),
                  decoration: InputDecoration(
                    labelText: "Usuário",
                    labelStyle: TextStyle(color: branco),
                    prefixIcon: Icon(Icons.account_circle, color: branco),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Informe o usuário" : null,
                ),

                SizedBox(height: 15),

                // EMAIL
                TextFormField(
                  controller: emailController,
                  style: TextStyle(color: branco),
                  decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: TextStyle(color: branco),
                    prefixIcon: Icon(Icons.email, color: branco),
                  ),
                  validator: (value) {
                    if (value == null || !value.contains('@')) {
                      return "Email inválido";
                    }
                    return null;
                  },
                ),

                SizedBox(height: 15),

                // SENHA
                TextFormField(
                  controller: passwordController,
                  obscureText: obscurePassword,
                  style: TextStyle(color: branco),
                  decoration: InputDecoration(
                    labelText: "Senha",
                    labelStyle: TextStyle(color: branco),
                    prefixIcon: Icon(Icons.lock, color: branco),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: branco,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 15),

                // CONFIRMAR SENHA
                TextFormField(
                  controller: passwordconfirmController,
                  obscureText: obscurePasswordConfirmar,
                  style: TextStyle(color: branco),
                  decoration: InputDecoration(
                    labelText: "Confirmar senha",
                    labelStyle: TextStyle(color: branco),
                  ),
                  validator: (value) {
                    if (value != passwordController.text) {
                      return "Senhas diferentes";
                    }
                    return null;
                  },
                ),

                SizedBox(height: 30),

                // BOTÃO
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: loading ? null : cadastro,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: laranja,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: loading
                        ? CircularProgressIndicator(color: preto)
                        : Text(
                            "CADASTRAR",
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
        ),
      ),
    );
  }
}