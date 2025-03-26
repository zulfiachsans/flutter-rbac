import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rbac/auth/auth_screen.dart';
import 'package:flutter_rbac/presentation/pages/report_page.dart';

class HomePage extends StatefulWidget {
  final String username; // Menerima username dari authform
  final Function(int) onTabChange;

  const HomePage(
      {super.key, required this.username, required this.onTabChange});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final CollectionReference ordersCollection =
        FirebaseFirestore.instance.collection('orders');
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      print("UID pengguna: ${user.uid}"); // 🔹 Debugging UID
    } else {
      print("Gagal mendapatkan UID pengguna.");
    }

    void _updateOrderStatus(String docId, bool newStatus) {
      ordersCollection.doc(docId).update({'status': newStatus});
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selamat datang, ${user?.displayName ?? "Pengguna"}',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Silakan pilih menu di bawah untuk melanjutkan.",
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(10),
                alignment: Alignment.centerLeft,
                child: const Text(
                  "📋 Daftar Pesanan",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: StreamBuilder(
                  stream: ordersCollection
                      .where('userId', isEqualTo: user?.uid)
                      .limit(5)
                      .snapshots(), // 🔹 Batasi 5 data
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text("Belum ada pesanan"));
                    }
                    return Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              var doc = snapshot.data!.docs[index];
                              Map<String, dynamic> order =
                                  doc.data() as Map<String, dynamic>;
                              bool isCompleted = order['status'];

                              return Card(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                child: ListTile(
                                  leading: const Icon(Icons.shopping_cart),
                                  title: Text(order['service']),
                                  subtitle: Row(
                                    children: [
                                      Text(
                                          "Status: ${isCompleted ? 'Selesai' : 'Belum Selesai'}"),
                                      const SizedBox(width: 8),
                                      Icon(
                                        isCompleted
                                            ? Icons.check_circle
                                            : Icons.hourglass_empty,
                                        color: isCompleted
                                            ? Colors.green
                                            : Colors.orange,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        if (snapshot.data!.docs.length >= 5)
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                widget.onTabChange(
                                    1); // 🔹 Fungsi untuk pindah tab ke OrderPage
                              },
                              child: SizedBox(
                                height: 200,
                                child: Text(
                                  "Lihat Semua Data",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
