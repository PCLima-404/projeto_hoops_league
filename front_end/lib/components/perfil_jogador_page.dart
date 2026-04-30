import 'package:flutter/material.dart';
import 'package:front_end/services/api_services.dart';

class PerfilJogadorPage extends StatefulWidget {
  final String username; // ← recebe o username do jogador

  const PerfilJogadorPage({super.key, required this.username});

  @override
  State<PerfilJogadorPage> createState() => _PerfilJogadorPageState();
}

class _PerfilJogadorPageState extends State<PerfilJogadorPage> {
  static const preto = Color(0xFF1A1413);
  static const laranja = Color(0xFFED5223);
  static const branco = Color(0xFFFDFDFD);

  Map<String, dynamic>? user;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    carregarPerfil();
  }

  void carregarPerfil() async {
    final resultado = await ApiService.get("/auth/buscar-usuario/${widget.username}");
    if (resultado != null && resultado is List && resultado.isNotEmpty) {
      setState(() {
        user = resultado[0]; 
        loading = false;
      });
    } else {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        backgroundColor: preto,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (user == null) {
      return const Scaffold(
        backgroundColor: preto,
        body: Center(
          child: Text("Jogador não encontrado", style: TextStyle(color: branco)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: preto,
      appBar: AppBar(
        backgroundColor: Colors.grey,
        foregroundColor: branco,
        title: Text(user!["user"] ?? ""),
      ),
      body: Column(
        children: [
          
          SizedBox(
            height: 260,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                const ColoredBox(
                  color: Colors.grey,
                  child: SizedBox(height: 140, width: double.infinity),
                ),
                const Positioned(
                  top: 60,
                  child: CircleAvatar(
                    radius: 42,
                    backgroundColor: preto,
                    child: CircleAvatar(
                      radius: 38,
                      backgroundColor: laranja,
                      child: Icon(Icons.person, size: 40, color: branco),
                    ),
                  ),
                ),
                Positioned(
                  top: 110,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: laranja,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Text(
                          user!["user"] ?? "",
                          style: const TextStyle(
                            color: branco,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              user!["posicao_preferida"] ?? "",
                              style: const TextStyle(color: branco, fontWeight: FontWeight.bold,
                              fontSize: 16
                              ),
                            ),
                            Text(
                              "${user!["altura"] ?? 0} m",
                              style: const TextStyle(color: branco, fontWeight: FontWeight.bold,
                              fontSize: 16
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${user!["idade"] ?? 0} anos",
                              style: const TextStyle(color: branco, fontWeight: FontWeight.bold,
                              fontSize: 16
                              ),
                            ),
                            Text(
                              "${user!["email"] ?? 0}",
                              style: TextStyle(color: branco,
                              fontWeight: FontWeight.bold,
                              fontSize: 16
                              ),

                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _StatCard(valor: '${user!["pontos"] ?? 0}', label: 'Pontos'),
                    _StatCard(valor: '${user!["assistencias"] ?? 0}', label: 'Assistências'),
                    _StatCard(valor: '${user!["rebotes"] ?? 0}', label: 'Rebotes'),
                  ],
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _StatCard(valor: '${user!["roubos"] ?? 0}', label: 'Roubos'),
                    _StatCard(valor: '${user!["bloqueios"] ?? 0}', label: 'Bloqueios'),
                    _StatCard(valor: '${user!["overall"] ?? 0}', label: 'Overall'),
                  ],
                ),
                const SizedBox(height: 25),
                _StatCard(valor: '${user!["jogos"] ?? 0}', label: 'Jogos disputados'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String valor;
  final String label;

  const _StatCard({required this.valor, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          valor,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }
}