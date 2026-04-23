// ignore_for_file: non_constant_identifier_names
import 'package:front_end/modules/models/jogador.dart';

class Partida {
  String local;
  DateTime data;
  String horario;
  List<Jogador> jogadores;
  String foto_url;

  Partida({
    required this.local,
    required this.data,
    required this.horario,
    required this.jogadores,
    this.foto_url = " ",
  });

  Map<String, dynamic> toJson() {
    return {
      'quadra': local,
      'data': DateTime(data.year, data.month, data.day),
      'horario': horario,
      'jogadores': jogadores.map((j) => j.toJson()).toList(),
      'foto_url': foto_url,
    };
  }

  factory Partida.fromJson(Map<String, dynamic> json) {
    return Partida(
      local: json['quadra'],
      data: json['data'],
      horario: json['horario'],
      jogadores: (json['jogadores'] as List).map((j) => Jogador.fromJson(j)).toList(),
      foto_url: json['foto_url'],
    );
  }
}
