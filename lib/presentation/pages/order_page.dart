import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rbac/utils/colors.dart';
import 'package:flutter_rbac/utils/text_style.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final CollectionReference ordersCollection =
      FirebaseFirestore.instance.collection('orders');
  final TextEditingController serviceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pemesanan")),
      body: Column(
        children: [
          // Notes Geser ke Kiri untuk Menghapus
          Container(
            padding: const EdgeInsets.all(8.0),
            color: AppColors.primaryColor,
            width: double.infinity,
            child: Text(
              "➡ Geser ke kiri untuk menghapus pesanan",
              textAlign: TextAlign.center,
              style: regularStyle.copyWith(
                fontSize: 12,
                color: AppColors.buttonColor,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: ordersCollection.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("Belum ada pesanan"));
                }

                return ListView(
                  children: snapshot.data!.docs.map((doc) {
                    Map<String, dynamic> order =
                        doc.data() as Map<String, dynamic>;
                    return Dismissible(
                      key: Key(doc.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      confirmDismiss: (direction) async {
                        return await _showDeleteConfirmation(doc.id);
                      },
                      child: Card(
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          leading: const Icon(Icons.shopping_cart),
                          title: Text(order['service']),
                          subtitle: Text(
                              "Status: ${order['status'] ? 'Selesai' : 'Belum Selesai'}"),
                          trailing: IconButton(
                            icon: Icon(
                              order['status']
                                  ? Icons.check_circle
                                  : Icons.hourglass_empty,
                              color: order['status']
                                  ? Colors.green
                                  : Colors.orange,
                            ),
                            onPressed: () {
                              _updateOrderStatus(doc.id, !order['status']);
                            },
                          ),
                          onTap: () => _showOrderDetails(order),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddOrderDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<bool?> _showDeleteConfirmation(String docId) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi Hapus"),
        content: const Text("Apakah Anda yakin ingin menghapus pesanan ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () async {
              await ordersCollection.doc(docId).delete();
              Navigator.pop(context, true);
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showOrderDetails(Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Detail Pesanan"),
        content: Text(
            "Layanan: ${order['service']}\nStatus: ${order['status'] ? 'Selesai' : 'Belum Selesai'}"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tutup"),
          ),
        ],
      ),
    );
  }

  void _updateOrderStatus(String docId, bool newStatus) {
    ordersCollection.doc(docId).update({'status': newStatus});
  }

  void _showAddOrderDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Tambah Pesanan"),
          content: TextField(
            controller: serviceController,
            decoration: const InputDecoration(
              labelText: "Nama Layanan",
              hintText: "Masukkan layanan yang dipesan",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                _createNewOrder();
                Navigator.pop(context);
              },
              child: const Text("Tambah"),
            ),
          ],
        );
      },
    );
  }

  void _createNewOrder() {
    if (serviceController.text.isNotEmpty) {
      ordersCollection.add({
        'service': serviceController.text,
        'status': false, // Default status: Belum selesai
      });
      serviceController.clear();
    }
  }
}
