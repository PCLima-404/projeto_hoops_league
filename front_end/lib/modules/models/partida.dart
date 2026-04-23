// ignore_for_file: non_constant_identifier_names
import 'package:front_end/modules/models/jogador.dart';

class Partida {
  String local;
  DateTime data;
  String horario;
  List<Jogador> jogadores;
  String ImgUrl;

  Partida({
    required this.local,
    required this.data,
    required this.horario,
    required this.jogadores,
    this.ImgUrl = " ",
  });

  Map<String, dynamic> toJson() {
    return {
      'quadra': local,
      'data': DateTime(data.year, data.month, data.day),
      'horario': horario,
      'jogadores': jogadores.map((j) => j.toJson()).toList(),
      'ImgUrl': ImgUrl,
    };
  }

  factory Partida.fromJson(Map<String, dynamic> json) {
    return Partida(
      local: json['quadra'],
      data: json['data'],
      horario: json['horario'],
      jogadores: (json['jogadores'] as List).map((j) => Jogador.fromJson(j)).toList(),
      ImgUrl: json['ImgUrl'],
    );
  }
}
