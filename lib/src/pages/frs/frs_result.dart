import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FrsResult extends StatefulWidget {
  const FrsResult({super.key});

  @override
  State<FrsResult> createState() => _FrsResultState();
}

class _FrsResultState extends State<FrsResult> {
  late Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> _frsData;

  @override
  void initState() {
    super.initState();
    _frsData = _fetchFrsData();
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      _fetchFrsData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final querySnapshot = await FirebaseFirestore.instance
        .collection('frs')
        .where('user_id', isEqualTo: userId)
        .get();
    return querySnapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FRS Results'),
      ),
      body: FutureBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
        future: _frsData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading data'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            final frsData = snapshot.data!;
            return ListView.builder(
              itemCount: frsData.length,
              itemBuilder: (context, index) {
                final doc = frsData[index];
                return ListTile(
                  title: Text('Document ${index + 1}'),
                  subtitle: Text(doc.id),
                );
              },
            );
          }
        },
      ),
    );
  }
}
