// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, avoid_print, unused_local_variable
import 'package:front_end/components/position_page.dart';
import 'package:flutter/material.dart';

class CadastroPage extends StatefulWidget {
  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordconfirmController =
      TextEditingController();

  final formKey = GlobalKey<FormState>();

  static const preto = Color(0xFF1A1413);
  static const laranja = Color(0xFFED5223);
  static const branco = Color(0xFFFDFDFD);

  bool obscurePassword = true;
  bool obscurePasswordConfirmar = true;
  void cadastro() {
    if (formKey.currentState!.validate()) {
      String nome = nomeController.text;
      String user = userController.text;
      String email = emailController.text;
      String password = passwordController.text;
      String passwordConfirm = passwordconfirmController.text;

      print("Formulário válido");
      print("Usuário  $user");

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PositionPage()),
      );
    } else {
      print("Formulário Inválido");
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
                  "Quer se desafiar e entrar para a elite do \nbasquete amador? Então não perca tempo!\nCrie seu perfil na HP!",
                  style: TextStyle(color: branco, fontSize: 15),
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: nomeController,
                  style: TextStyle(color: branco),
                  decoration: InputDecoration(
                    labelText: "Nome:",
                    labelStyle: TextStyle(color: branco),
                    prefixIcon: Icon(
                      Icons.people,
                      color: branco,
                    ),
                    hintText: "Informe seu nome completo",
                    contentPadding: EdgeInsets.symmetric(vertical: 18),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: branco),
                    ),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "informe o nome completo" : null,
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: userController,
                  style: TextStyle(color: branco),
                  decoration: InputDecoration(
                    labelText: "Usuário:",
                    labelStyle: TextStyle(color: branco),
                    prefixIcon: Icon(Icons.supervised_user_circle, color: branco,),
                    hintText: "Digite seu usuário",
                    hintStyle: TextStyle(color: branco),
                    contentPadding: EdgeInsets.symmetric(vertical: 18),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: branco)
                    )
                  ),
                  validator: (value) => value!.isEmpty ? "Informe o usuário" : null,
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: emailController,
                  style: TextStyle(color: branco),
                  decoration: InputDecoration(
                    labelText: "E-mail:",
                    labelStyle: TextStyle(color: branco),
                    hintText: "Jogador@mail.com",
                    prefixIcon: Icon(Icons.email_outlined, color: branco),
                    contentPadding: EdgeInsets.symmetric(vertical: 18),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: branco),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || !value.contains('@')) {
                      return "email inválido";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: passwordController,
                  style: TextStyle(color: branco),
                  obscureText: obscurePassword,
                  decoration: InputDecoration(
                    labelText: "Senha:",
                    labelStyle: TextStyle(color: branco),
                    hintText: "Digite sua senha",
                    prefixIcon: Icon(Icons.supervised_user_circle, color: branco),
                    contentPadding: EdgeInsets.symmetric(vertical: 18),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: branco),
                    ),
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
                TextFormField(
                  controller: passwordconfirmController,
                  style: TextStyle(color: branco),
                  obscureText: obscurePasswordConfirmar,
                  decoration: InputDecoration(
                    labelText: "    Confirmação senha",
                    labelStyle: TextStyle(color: branco),
                    hintText: "Confirme sua senha",
                    contentPadding: EdgeInsets.symmetric(vertical: 18),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: branco),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscurePasswordConfirmar = !obscurePasswordConfirmar;
                        });
                      },
                      icon: Icon(
                        obscurePasswordConfirmar
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: branco,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "confirme sua senha";
                    }
                    if (value != passwordController.text) {
                      return "As senhas não são iguais";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: cadastro,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: laranja,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: Text(
                      "CADASTRAR",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: preto,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(color: branco, fontSize: 14),
                    children: [
                      TextSpan(
                        text: "Clicando em 'cadastrar' você aceita nossos",
                      ),
                      TextSpan(
                        text: " termos",
                        style: TextStyle(
                          color: laranja,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(text: " e "),
                      TextSpan(
                        text: "condições",
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
        ),
      ),
    );
  }
}
