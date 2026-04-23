// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:front_end/components/cadastro_page.dart';
import 'package:front_end/components/position_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;
  static const preto = Color(0xFF1A1413);
  static const laranja = Color(0xFFED5223);
  static const branco = Color(0xFFFDFDFD);
  static const vermelho = Color(0xFFB71C1C);

  final formKey = GlobalKey<FormState>();

  void login() {
    if (formKey.currentState!.validate()) {
      String user = userController.text;
      String password = passwordController.text;

      print("Usuário: $user");
      print("Senha $password");

      Navigator.push(context, MaterialPageRoute(builder: (context) => PositionPage()));

    } else {
      print("Login inválido!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: laranja,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 120),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/logoPequena.png", height: 60),
                      SizedBox(width: 18),

                      Text(
                        "Hoops League",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: branco,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 50),
                const Text(
                  "ENTRAR",
                  style: TextStyle(
                    color: branco,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 30),

                TextFormField(
                  controller: userController,
                  style: TextStyle(color: branco),
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: branco),
                    labelText: "Usuário",
                    errorStyle: TextStyle(
                      color: vermelho,
                      fontWeight: FontWeight.bold,
                    ),
                    prefixIcon: Icon(
                      Icons.supervised_user_circle,
                      color: branco,
                    ),
                    hintText: "Digite seu apelido",
                    hintStyle: TextStyle(color: branco),

                    contentPadding: EdgeInsets.symmetric(vertical: 18),

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: branco),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: branco, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Informe o usuário";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                TextFormField(
                  controller: passwordController,
                  style: TextStyle(color: branco),
                  obscureText: obscurePassword,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.verified_user, color: branco),
                    hintText: "Digite sua senha",
                    hintStyle: TextStyle(color: branco),
                    label: Text("Senha"),
                    labelStyle: TextStyle(color: branco),
                    errorStyle: TextStyle(
                      color: vermelho,
                      fontWeight: FontWeight.bold,
                    ),

                    contentPadding: EdgeInsets.symmetric(vertical: 20),

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: branco),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: branco, width: 2),
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Informe a senha";
                    }
                    return null;
                  },
                ),

                SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: preto,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: Text(
                      "LOGIN",
                      style: TextStyle(fontSize: 16, color: branco),
                    ),
                  ),
                ),

                SizedBox(height: 70),

                SizedBox(
                  child: Text(
                    "Não tem uma conta?",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 179, 178, 178),
                    ),
                  ),
                ),

                SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CadastroPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: preto,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: Text(
                      "CRIAR CONTA",
                      style: TextStyle(fontSize: 16, color: branco),
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
