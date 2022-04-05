import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stocksmanager/view/pages/drawer_pages/income_pages/income_page.dart';

import '../pages/drawer_pages/advance_pages/advance_page.dart';
import '../pages/drawer_pages/all_customers_page.dart';
import '../pages/drawer_pages/expenses_pages/expenses_page.dart';
import '../pages/drawer_pages/home_page.dart';
import '../pages/drawer_pages/machine_page.dart';
import '../pages/drawer_pages/pumba.dart';
import '../pages/drawer_pages/stock_pages/stock_page.dart';

User? user;

final FirebaseAuth auth = FirebaseAuth.instance;

class NewDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('${auth.currentUser?.uid}'),
            accountEmail: Text('${auth.currentUser?.email}'),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset(
                  'images/2.jpg',
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            decoration: const BoxDecoration(
              color: Colors.amberAccent,
              image: DecorationImage(
                image: AssetImage('images/2.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const ListTile(
            title: Text('Balance:'),
            trailing: Text('Tsh 10,456,450/='),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.event_available),
            title: const Text('Advance'),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => AdvancePage()));
            },
          ),
          ListTile(
              leading: const Icon(Icons.people),
              title: const Text('All Customers'),
              trailing: ClipOval(
                child: Container(
                  color: Colors.teal,
                  width: 30,
                  height: 30,
                  child: const Center(
                    child: Text(
                      '102',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AllCustomersPage()));
              }),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Income'),
            trailing: const Text('Tsh 6,885,000/='),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => IncomePage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.paid),
            title: const Text('EXpenses'),
            trailing: const Text('Tsh 809,000/='),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => ExpensesPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.inventory),
            title: const Text('Stock'),
            trailing: ClipOval(
              child: Container(
                color: Colors.red,
                width: 20,
                height: 20,
                child: const Center(
                  child: Text(
                    '52',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => StockPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.water_drop),
            title: const Text('Kilo za mashine'),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => MachinePage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.luggage),
            title: const Text('Pumba'),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => PumbaPage()));
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Icon(
                          Icons.facebook,
                          color: Colors.teal.shade600,
                        )),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Icon(
                          Icons.event_available,
                          color: Colors.teal.shade600,
                        )),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Icon(
                          Icons.contact_mail,
                          color: Colors.teal.shade600,
                        )),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Icon(
                          Icons.email,
                          color: Colors.teal.shade600,
                        )),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Icon(
                          Icons.phone,
                          color: Colors.teal.shade600,
                        )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
