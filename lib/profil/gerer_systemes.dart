import 'package:flutter/material.dart';
import '../models/system_model.dart';
import '/home/system_detail_page.dart'; // Adjust path if necessary

class ManageSystemsPage extends StatelessWidget {
  final List<System> systems;

  const ManageSystemsPage({super.key, required this.systems});

  static const Color darkGreen = Color(0xFF2D442E);
  static const Color lightGreenTile = Color(0xFFD7E5D0);
  static const Color bgMain = Color(0xFFF9F9F7);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgMain,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: darkGreen),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Gérer les systèmes",
          style: TextStyle(color: darkGreen, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: systems.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: systems.length,
              separatorBuilder: (context, index) => const SizedBox(height: 15),
              itemBuilder: (context, index) {
                return _buildSystemItem(context, systems[index]);
              },
            ),
    );
  }

  Widget _buildSystemItem(BuildContext context, System system) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SystemDetailPage(system: system),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        decoration: BoxDecoration(
          color: lightGreenTile,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              system.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: darkGreen,
              ),
            ),
            const CircleAvatar(
              backgroundColor: Colors.white,
              radius: 15,
              child: Icon(Icons.chevron_right, color: darkGreen, size: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.solar_power_outlined, size: 80, color: darkGreen.withOpacity(0.2)),
          const SizedBox(height: 10),
          const Text("Aucun système trouvé", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}