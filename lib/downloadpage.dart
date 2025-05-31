import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DownloadPage extends StatefulWidget {
  const DownloadPage({super.key});

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {

  final List<Map<String, String>> users = const [
    {
      'name': 'Ali Raza',
      'email': 'ali.raza@example.com',
      'phone': '0300-1234567',
    },
    {
      'name': 'Sara Khan',
      'email': 'sara.khan@example.com',
      'phone': '0311-9876543',
    },
    {
      'name': 'Ahmed Noor',
      'email': 'ahmed.noor@example.com',
      'phone': '0322-1112233',
    },
    {
      'name': 'Fatima Zahra',
      'email': 'fatima.zahra@example.com',
      'phone': '0333-4455667',
    },
  ];

  void _showDeletePopup() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Are you sure you want to delete?',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              ElevatedButton.icon(
                icon: Icon(Icons.delete),
                label: Text('Delete'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Deleted successfully')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _showDeletePopup,
            icon: Icon(Icons.delete),
          ),
        ],
        backgroundColor: CupertinoColors.systemBlue,
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return Card(
            margin: EdgeInsets.all(10),
            elevation: 4,
            child: ListTile(
              leading: Icon(Icons.person, color: Colors.blue),
              title: Text(user['name'] ?? ''),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user['email'] ?? ''),
                  Text(user['phone'] ?? ''),
                ],
              ),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}