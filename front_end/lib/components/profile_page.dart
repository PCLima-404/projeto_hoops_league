import 'package:flutter/material.dart';
import 'package:front_end/app_colors.dart';
import 'package:front_end/components/buscar_jogador_page.dart';
import 'package:front_end/components/buscar_partida_page.dart';
import 'package:front_end/components/edit_profile_page.dart';
import 'package:front_end/services/api_services.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? user;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    carregarUsuario();
  }

  void carregarUsuario() async {
    final data = await ApiService.getProfile();

    setState(() {
      user = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        backgroundColor: AppColors.preto,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (user == null) {
      return const Scaffold(
        backgroundColor: AppColors.preto,
        body: Center(child: Text("Erro ao carregar usuário")),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.preto,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          _ProfileHeader(user: user!),
          Expanded(child: _ProfileBody(user: user!)),
        ],
      ),
      bottomNavigationBar: _ProfileBottomNav(context: context),
    );
  }

  AppBar _buildAppBar(BuildContext context) => AppBar(
        backgroundColor: Colors.grey,
        elevation: 0,
        leading: IconButton(
          color: AppColors.branco,
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      );
}

class _ProfileHeader extends StatelessWidget {
  final Map<String, dynamic> user;

  const _ProfileHeader({required this.user});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          const ColoredBox(
              color: Colors.grey,
              child: SizedBox(height: 140, width: double.infinity)),

          const Positioned(
            top: 60,
            child: CircleAvatar(
              radius: 42,
              backgroundColor: AppColors.preto,
              child: CircleAvatar(
                radius: 38,
                backgroundColor: AppColors.laranja,
                child: Icon(Icons.person, size: 40, color: AppColors.branco),
              ),
            ),
          ),

          Positioned(
            top: 110,
            child: _ProfileCard(user: user),
          ),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final Map<String, dynamic> user;

  const _ProfileCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.laranja,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(user["user"],
              style: const TextStyle(
                  color: AppColors.branco,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),

          const SizedBox(height: 10),

          _ProfileRow(
            left: user["posicao_preferida"],
            right: "${user["altura"]} m",
          ),

          const SizedBox(height: 5),

          _ProfileRow(
            left: "${user["idade"]} anos",
            right: user["email"],
          ),
        ],
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  final String left;
  final String right;

  const _ProfileRow({required this.left, required this.right});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(left,
            style: const TextStyle(
                color: AppColors.branco, fontWeight: FontWeight.bold)),
        Text(right,
            style: const TextStyle(
                color: AppColors.branco, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _ProfileBody extends StatelessWidget {
  final Map<String, dynamic> user;

  const _ProfileBody({required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _StatCard(valor: '${user["pontos"]}', label: 'Pontos'),
              _StatCard(valor: '${user["assistencias"]}', label: 'Assistências'),
              _StatCard(valor: '${user["rebotes"]}', label: 'Rebotes'),
            ],
          ),

          const SizedBox(height: 25),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _StatCard(valor: '${user["roubos"]}', label: 'Roubos'),
              _StatCard(valor: '${user["bloqueios"]}', label: 'Bloqueios'),
              _StatCard(valor: '${user["overall"]}', label: 'Overall'),
            ],
          ),

          const SizedBox(height: 25),

          _StatCard(valor: '${user["jogos"]}', label: 'Jogos'),

          const Spacer(),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const EditProfilePage()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.laranja,
                  ),
                  child: const Text("Editar"),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text("Deletar"),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
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
        Text(valor,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }
}

class _ProfileBottomNav extends StatelessWidget {
  final BuildContext context;

  const _ProfileBottomNav({required this.context});

  void _onTap(int index) {
    switch (index) {
      case 1:
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => BuscarPartidaPage()));
        break;
      case 2:
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => BuscarJogadorPage()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: AppColors.laranja,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.branco,
      unselectedItemColor: AppColors.branco,
      currentIndex: 3,
      onTap: _onTap,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.house), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.sports_basketball), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
      ],
    );
  }
}