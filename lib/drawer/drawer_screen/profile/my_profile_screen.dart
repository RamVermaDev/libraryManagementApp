import 'package:flutter/material.dart';
import 'package:library_management/drawer/drawerWidgets/app_bar_widget.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(title: 'My Profile'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFFD0E6FF),
              child: Icon(Icons.person, size: 60, color: Colors.blue),
            ),

            const SizedBox(height: 16),

            const Text(
              'Ramendra Verma',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            Text(
              'ram@gmail.com',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
            ),

            const SizedBox(height: 30),

            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: const [
                    ProfileTile(title: "Name", value: "Ramendra Verma"),
                    Divider(),

                    ProfileTile(title: "Email", value: "ram@gmail.com"),
                    Divider(),

                    ProfileTile(title: "Role", value: "Library Owner"),
                    Divider(),

                    ProfileTile(title: "Status", value: "Active"),
                    Divider(),

                    ProfileTile(title: "Email Verification", value: "Verified"),
                    Divider(),

                    ProfileTile(title: "Libraries", value: "2"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.edit),
                label: const Text("Edit Profile"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileTile extends StatelessWidget {
  final String title;
  final String value;

  const ProfileTile({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
