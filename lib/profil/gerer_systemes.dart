import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/system_model.dart';
import '/home/system_detail_page.dart';
// 👇 IMPORT THIS FILE so the button knows where to go
import '../home/ajoutsystem.dart'; 

class ManageSystemsPage extends StatelessWidget {
  const ManageSystemsPage({super.key});

  static const Color darkGreen = Color(0xFF2D442E);
  static const Color lightGreenTile = Color(0xFFD7E5D0);
  static const Color bgMain = Color(0xFFF9F9F7);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

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
      
      // 👇 ADD THE BUTTON HERE (Inside Scaffold)
      floatingActionButton: FloatingActionButton(
        backgroundColor: darkGreen,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (_) => const AddSystemPage())
          );
        },
      ),

      // Use StreamBuilder to listen to Firestore changes
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid)
            .collection('systems')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Une erreur est survenue"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: darkGreen));
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: docs.length,
            separatorBuilder: (context, index) => const SizedBox(height: 15),
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final system = System.fromMap(data, docs[index].id);
              
              return _buildSystemItem(context, system, docs[index].reference);
            },
          );
        },
      ),
    );
  }

  Widget _buildSystemItem(BuildContext context, System system, DocumentReference docRef) {
    return Dismissible(
      key: Key(system.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        docRef.delete(); 
      },
      child: InkWell(
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
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.solar_power_outlined, size: 80, color: darkGreen.withValues(alpha: 0.2)),
          const SizedBox(height: 10),
          const Text("Aucun système trouvé", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}