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

  factory PlayerStats.fromJson(Map<String, dynamic> json) => PlayerStats(
    pontos: json['pontos'],
    assistencias: json['assistencias'],
    rebotes: json['rebotes'],
    roubos: json['roubos'],
    bloqueios: json['bloqueios'],
    overall: json['overall'],
    jogos: json['jogos'],
  );
}
