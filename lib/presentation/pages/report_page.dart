import 'package:flutter/material.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Laporan")),
      body: const Center(
        child: Text("Halaman Laporan (Belum ada data)"),
      ),
    );
  }
}
