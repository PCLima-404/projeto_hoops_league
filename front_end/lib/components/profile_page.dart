// profile_page.dart
import 'package:flutter/material.dart';
import 'package:front_end/app_colors.dart';
import 'package:front_end/components/buscar_jogador_page.dart';
import 'package:front_end/components/buscar_partida_page.dart';
import 'package:front_end/components/edit_profile_page.dart';
import 'package:front_end/modules/models/player_stats.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const _stats = PlayerStats(
    pontos: 108, assistencias: 40, rebotes: 38,
    roubos: 19, bloqueios: 60, overall: 74, jogos: 10,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.preto,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          const _ProfileHeader(),
          Expanded(child: _ProfileBody(stats: _stats)),
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
    actions: const [Icon(Icons.more_vert, color: AppColors.branco)],
  );
}

// ── Header ────────────────────────────────────────────────

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          const ColoredBox(color: Colors.grey, child: SizedBox(height: 140, width: double.infinity)),
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
            child: _ProfileCard(width: MediaQuery.of(context).size.width * 0.9),
          ),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final double width;
  const _ProfileCard({required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.laranja,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        children: [
          Text("Jogador", style: TextStyle(color: AppColors.branco, fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          _ProfileRow(left: "Armador", right: "1.90 cm"),
          SizedBox(height: 5),
          _ProfileRow(left: "22 anos", right: "jogador@mail.com"),
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
    const style = TextStyle(color: AppColors.branco, fontWeight: FontWeight.bold);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(left, style: style), Text(right, style: style)],
    );
  }
}

// ── Body ─────────────────────────────────────────────────

class _ProfileBody extends StatelessWidget {
  final PlayerStats stats;
  const _ProfileBody({required this.stats});

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
              _StatCard(valor: '${stats.pontos}', label: 'Pontos'),
              _StatCard(valor: '${stats.assistencias}', label: 'Assistências'),
              _StatCard(valor: '${stats.rebotes}', label: 'Rebotes'),
            ],
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _StatCard(valor: '${stats.roubos}', label: 'Roubos'),
              _StatCard(valor: '${stats.bloqueios}', label: 'Bloqueios'),
              _StatCard(valor: '${stats.overall}', label: 'Overall'),
            ],
          ),
          const SizedBox(height: 25),
          _StatCard(valor: '${stats.jogos}', label: 'Jogos disputados'),
          const Spacer(),
          _ActionButtons(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ── Stat Card ─────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String valor;
  final String label;
  const _StatCard({required this.valor, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(valor, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }
}

// ── Action Buttons ────────────────────────────────────────

class _ActionButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _OrangeButton(label: 'Editar perfil', onPressed: () =>
          Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfilePage())))),
        const SizedBox(width: 10),
        Expanded(child: _OrangeButton(label: 'Deletar conta', onPressed: () {})),
      ],
    );
  }
}

class _OrangeButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const _OrangeButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.laranja,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      onPressed: onPressed,
      child: Text(label, style: const TextStyle(color: AppColors.branco)),
    );
  }
}

// ── Bottom Nav ────────────────────────────────────────────

class _ProfileBottomNav extends StatelessWidget {
  final BuildContext context;
  const _ProfileBottomNav({required this.context});

  void _onTap(int index) {
    switch (index) {
      case 1: Navigator.push(context, MaterialPageRoute(builder: (_) => BuscarPartidaPage())); break;
      case 2: Navigator.push(context, MaterialPageRoute(builder: (_) => BuscarJogadorPage())); break;
      case 3: break; // já estamos no perfil
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: AppColors.laranja,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.branco,
      unselectedItemColor: AppColors.branco,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: 3,
      onTap: _onTap,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.house, size: 35), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.sports_basketball, size: 35), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.search, size: 35), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.person_2_outlined, size: 35), label: ''),
      ],
    );
  }
}