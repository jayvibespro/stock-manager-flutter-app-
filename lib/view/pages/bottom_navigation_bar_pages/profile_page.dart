import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stocksmanager/view/components/drawer.dart';

import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user;

  final FirebaseAuth auth = FirebaseAuth.instance;

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NewDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    child: ClipOval(
                      child: Image.asset(
                        'images/2.jpg',
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          '${auth.currentUser?.uid}',
                          style: const TextStyle(fontSize: 16),
                          overflow: TextOverflow.fade,
                        ),
                      ),
                      Text(
                        '${auth.currentUser?.email}',
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 32),
              child: Divider(
                thickness: 1,
              ),
            ),
            const ListTile(
              title: Text('Name'),
              trailing: Text('Steve Wonder'),
            ),
            const ListTile(
              title: Text('Phone number'),
              trailing: Text('0629919242 '),
            ),
            const ListTile(
              title: Text('Gender'),
              trailing: Text('Male'),
            ),
            const ListTile(
              title: Text('email'),
              trailing: Text('wondersteve001@gmail.com'),
            ),
            const ListTile(
              title: Text('Location'),
              trailing: Text('Kahama'),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 32, 16, 32),
              child: GestureDetector(
                child: Container(
                  width: double.infinity,
                  height: 60,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.amberAccent,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(143, 148, 251, 1),
                        blurRadius: 10.0,
                        offset: Offset(2, 6),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'Edit profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditProfilePage()));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
