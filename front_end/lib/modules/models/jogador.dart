// ignore_for_file: non_constant_identifier_names

class Jogador {
  String nome;
  String usuario;
  int overall;
  String ImgUrl;
  int idade;
  String email;
  double altura;

  Jogador({
    required this.nome,
    required this.overall,
    this.ImgUrl = " ",
    required this.usuario,
    required this.idade,
    required this.email,
    required this.altura,
  });

  factory Jogador.fromJson(Map<String, dynamic> json) {
    return Jogador(
      nome: json['nome'],
      usuario: json['usuario'],
      overall: json['overall'],
      ImgUrl: json['ImgUrl'],
      idade: json['ImgUrl'],
      email: json['email'],
      altura: json['altura'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'usuario': usuario,
      'overall': overall,
      'ImgUrl': ImgUrl,
      'email' : email,
      'altura' : altura,
    };
  }
}
