// ignore_for_file: avoid_print
import 'package:front_end/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:front_end/components/buscar_jogador_page.dart';

class PositionPage extends StatefulWidget {
  const PositionPage({super.key});

  @override
  State<PositionPage> createState() => _PositionPageState();
}

class _PositionPageState extends State<PositionPage> {

  double idade = 10.0;
  double altura = 1.40;

  int selectIndex = -1;
  final List<String> positions = [
    "Armador",
    "Ala-Armador",
    "Ala",
    "Ala-Pivô",
    "Pivô",
    "Não sei",
  ];

  void confirmar() {
    print("Idade: ${idade.toInt()}");
    print("Altura ${altura.toStringAsFixed(2)}");
    print(
      "Posição: ${selectIndex >= 0 ? positions[selectIndex] : positions[5]}",
    );
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
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                textAlign: TextAlign.center,
                "Qual a posição que você gosta de jogar?",
                style: TextStyle(
                  color: AppColors.laranja,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 35),
        
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: positions.length,
                  itemBuilder: (context, index) {
                    bool isSelected = selectIndex == index;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectIndex = index;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 10),
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.laranja : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.laranja),
                        ),
                        child: Center(
                          child: Text(
                            positions[index],
                            style: TextStyle(
                              color: isSelected ? AppColors.preto : AppColors.branco,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
        
              SizedBox(height: 50),
              Text(
                "Idade: ${idade.toInt()}",
                style: TextStyle(
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
                  itemExtent:  40, 
                  onSelectedItemChanged: (int index){
                    setState(() {
                      idade = (index + 10).toDouble();
                    });
                  }, 
                  children: List<Widget>.generate(51, (int index){
                    return Center(
                      child: Text(
                        "${index + 10}",
                        style: TextStyle(color: AppColors.laranja, fontSize: 24),
                      ),
                    );
                  })
                  ),
              ),
              SizedBox(height: 20),
        
              Text(
                "Altura: ${altura.toStringAsFixed(2)} m",
                style: TextStyle(
                  color: AppColors.laranja,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Slider(
                value: altura,
                min: 1.40,
                max: 2.30,
                divisions: 80,
                activeColor: AppColors.laranja,
                onChanged: (value) {
                  setState(() {
                    altura = value;
                  });
                },
              ),
        
              SizedBox(height: 150),
        
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: selectIndex >= 0 
                  ? () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => BuscarJogadorPage()));
                     }
                  : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectIndex >= 0 ? AppColors.laranja : Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Text(
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
