// ignore_for_file: avoid_print
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:front_end/app_colors.dart';
import 'package:front_end/components/profile_page.dart';
import 'package:front_end/services/api_services.dart';

class PositionPage extends StatefulWidget {
  const PositionPage({super.key});

  @override
  State<PositionPage> createState() => _PositionPageState();
}

class _PositionPageState extends State<PositionPage> {
  double idade = 18;
  double altura = 1.70;

  int selectIndex = -1;
  bool loading = false;

  final List<String> positions = [
    "Armador",
    "Ala-Armador",
    "Ala",
    "Ala-Pivô",
    "Pivô",
    "Não sei",
  ];

Future<void> confirmar() async {
  if (selectIndex < 0) return;

  setState(() => loading = true);

 
  final Map<String, String> tradutorPosicao = {
    "Armador": "armador",
    "Ala-Armador": "ala_armador",
    "Ala": "ala",
    "Ala-Pivô": "ala_pivo",
    "Pivô": "pivo",
    "Não sei": "nao_sei",
  };

  final posicaoFormatada = tradutorPosicao[positions[selectIndex]] ?? "nao_sei";

  final sucesso = await ApiService.updateProfile({
    "idade": idade.toInt(),
    "altura": altura,
    "posicao_preferida": posicaoFormatada, 
  });

  if (!mounted) return;
  setState(() => loading = false);

  if (sucesso) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const ProfilePage()),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Erro ao salvar perfil. Verifique os dados.")),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.preto,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.preto,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Qual a posição que você gosta de jogar?",
                style: TextStyle(
                  color: AppColors.laranja,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 35),

              // POSIÇÕES
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: positions.length,
                  itemBuilder: (context, index) {
                    final isSelected = selectIndex == index;

                    return GestureDetector(
                      onTap: () => setState(() => selectIndex = index),
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.laranja
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.laranja),
                        ),
                        child: Center(
                          child: Text(
                            positions[index],
                            style: TextStyle(
                              color: isSelected
                                  ? AppColors.preto
                                  : AppColors.branco,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 50),

              // IDADE
              Text(
                "Idade: ${idade.toInt()}",
                style: const TextStyle(
                  color: AppColors.laranja,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(
                height: 150,
                child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(
                    initialItem: idade.toInt() - 10,
                  ),
                  itemExtent: 40,
                  onSelectedItemChanged: (index) {
                    setState(() {
                      idade = (index + 10).toDouble();
                    });
                  },
                  children: List.generate(51, (index) {
                    return Center(
                      child: Text(
                        "${index + 10}",
                        style: const TextStyle(
                          color: AppColors.laranja,
                          fontSize: 24,
                        ),
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 20),

              // ALTURA
              Text(
                "Altura: ${altura.toStringAsFixed(2)} m",
                style: const TextStyle(
                  color: AppColors.laranja,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Slider(
                value: altura,
                min: 1.40,
                max: 2.30,
                divisions: 90,
                activeColor: AppColors.laranja,
                onChanged: (value) {
                  setState(() => altura = value);
                },
              ),

              const SizedBox(height: 100),

              // BOTÃO
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: (selectIndex >= 0 && !loading)
                      ? confirmar
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectIndex >= 0
                        ? AppColors.laranja
                        : Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: loading
                      ? const SizedBox(
                          width: 25,
                          height: 25,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Colors.black,
                          ),
                        )
                      : const Text(
                          "CONFIRMAR",
                          style: TextStyle(
                            color: AppColors.preto,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
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