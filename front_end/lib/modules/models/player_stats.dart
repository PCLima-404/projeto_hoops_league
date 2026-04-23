class PlayerStats {
  final int pontos;
  final int assistencias;
  final int rebotes;
  final int roubos;
  final int bloqueios;
  final int overall;
  final int jogos;

  const PlayerStats({
    required this.pontos,
    required this.assistencias,
    required this.rebotes,
    required this.roubos,
    required this.bloqueios,
    required this.overall,
    required this.jogos,
  });

  factory PlayerStats.fromJson(Map<String, dynamic> json) {
    return PlayerStats(
      pontos: json['pontos'] ?? 0,
      assistencias: json['assistencias'] ?? 0,
      rebotes: json['rebotes'] ?? 0,
      roubos: json['roubos'] ?? 0,
      bloqueios: json['bloqueios'] ?? 0,
      overall: json['overall'] ?? 0,
      jogos: json['jogos'] ?? 0,
    );
  }
}